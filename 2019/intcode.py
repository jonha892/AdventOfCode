class Intcode:
    def __init__(self, prog, phase=-1, phase_input=-1, with_input=False, stepwise=True):
        self.prog = prog[:]
        self.index = 0
        self.output = 0
        self.relative_base = 0
        
        self.with_input = with_input
        self.stepwise = stepwise
        
        self.phase = phase
        self.phase_input = phase_input
        self.set_phase = True
        
        self.finished = False
        
    def set_phase_input(self, p):
        self.phase_input = p
    
    def _read_addr(self, addr):
        if addr < 0:
            raise ValueError('Access to negative aggress {}'.format(addr, len(self.prog)))
        if addr >= len(self.prog):
            print('Extending memory. Addr: ', addr, ' len: ', len(self.prog))
            #print('old prog', self.prog)
            self.prog = self.prog[:] + [0] * (addr - len(self.prog) +1)
            #print('new prog', self.prog)
        v = self.prog[addr]
        #print('Value at addr', addr, ' is ', v)
        return v
    
    def _set_addr(self, addr, value):
        if addr < 0:
            raise ValueError('Setting negative aggress {}'.format(addr, len(self.prog)))
        if addr >= len(self.prog):
            print('Set addr. Extending memory. Addr: ', addr, ' len: ', len(self.prog))
            #print('old prog', self.prog)
            self.prog = self.prog[:] + [0] * (addr - len(self.prog) +1)
            #print('new prog', self.prog)
        #print('Value at addr {} is now {}'.format(addr, value))
        self.prog[addr] = value
    
    def _get_save_addr(self, mode, v):
        mode = int(mode)
        if mode == 0:
            return v
        elif mode == 2:
            return self.relative_base + v
        else:
            raise ValueError('unknown op: {} {}'.format(mode, type(mode)))
            
    def _get_operands(self, op_str, parameters, addr_only=False):
        # reverse string
        modes = op_str[-2-parameters:-2][::-1]
        modes = list(map(int, modes))
        operands = []
        for i, m in enumerate(modes):
            if m == 0:
                addr = self.prog[self.index + i + 1]
                v = self._read_addr(addr)
            elif m == 1:
                v = self.prog[self.index + i + 1]
            elif m == 2:
                addr = self.relative_base + self.prog[self.index + i + 1]
                v = self._read_addr(addr)
                #print('Get operands base/addr/v', self.relative_base, addr, v)
                    
            else:
                raise ValueError('unknown parameter mode: {} {}'.format(m, type(m)))
            operands.append(v)
        #print(op_str, modes, operands)
        return operands
    
    
    def run(self, one_input=-1):
        outputs = []
        op = self.prog[self.index]
        i = 0
        while op != 99:
            #print(op)
            op_s = str(op).zfill(5)
            op_old = op
            op = int(op_s[-2:])
            #print(self.prog[self.index:self.index+4])
            if op == 1:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                c = self._get_save_addr(op_s[0], self.prog[self.index + 3])
                self._set_addr(c, a+b)
                self.index = self.index + 4
            elif op == 2:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                c = self._get_save_addr(op_s[0], self.prog[self.index + 3])
                self._set_addr(c, a*b)
                self.index = self.index + 4
            elif op == 3:
                #values = self._get_operands(op_s, 1, addr_only=True)
                #c = values[0]
                c = self._get_save_addr(op_s[2], self.prog[self.index + 1])
                #print('op3', op_s, c, self.relative_base, self.prog[self.index:self.index+3])
                if self.with_input:
                    r = input('INTCODE AWAITS INPUT:')
                elif one_input != -1:
                    r = one_input
                elif not self.with_input and self.set_phase:
                    r = self.phase
                    self.set_phase = False
                elif not self.with_input and not self.set_phase:
                    r = self.phase_input
                else:
                    raise ValueError('Unknown input mode {} {}'.format(self.with_input, self.set_phase))
                #print(r, type(r))
                self._set_addr(c, int(r))
                self.index = self.index + 2
            elif op == 4:
                values = self._get_operands(op_s, 1)
                a = values[0]
                print('INTCODE print: ', a)
                self.index = self.index + 2
                self.output = a
                outputs.append(a)
                if self.stepwise:
                    print('return on op 4')
                    return
            elif op == 5:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                if a != 0:
                    self.index = b
                else:
                    self.index = self.index + 3
            elif op == 6:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                if a == 0:
                    self.index = b
                else:
                    self.index = self.index + 3
            elif op == 7:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                #c = self.prog[self.index + 3]
                c = self._get_save_addr(op_s[0], self.prog[self.index + 3])
                r = 1 if a < b else 0
                self._set_addr(c, r)
                self.index = self.index + 4
            elif op == 8:
                values = self._get_operands(op_s, 2)
                a = values[0]
                b = values[1]
                c = self._get_save_addr(op_s[0], self.prog[self.index + 3])
                r = 1 if a == b else 0
                self._set_addr(c, r)
                self.index = self.index + 4
            elif op == 9:
                #print(op_s)
                values = self._get_operands(op_s, 1)
                a = values[0]
                old = self.relative_base
                self.relative_base += a
                #print('changing base', self.relative_base, old, a, self.prog[self.index:self.index+2])
                self.index = self.index + 2
            else:
                raise ValueError('unknown op: ' + str(op) + ' ' + op_s)

            op = self.prog[self.index]
            #print('----')
            i += 1
            print(i)
        self.finished = True
        print(outputs)