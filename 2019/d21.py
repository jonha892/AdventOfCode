from itertools import repeat
from multiprocessing import Pool
import sys

from intcode_11 import Intcode

def encode_prog(p, w=False):
    e = 'WALK'
    if w:
        e = 'RUN'
    r = []
    for l in p:
        x = [ord(c) for c in l] + [10]
        r += x
    r = r + [ord(c) for c in e] + [10]
    return r
def decode(p):
    print(p)
    return ''.join([chr(x) for x in p])

def try_prog(idx, encoded_springscript, int_code):
    if idx % 1000 == 0:
        print(idx)
    c = Intcode(int_code)
    o = c.run(input_list=encoded_springscript)
    if o[-1] < 100:
        #print(o, decode(encoded_springscript))
        return (False, o, '')
    print('Found solution', o, decode(encoded_springscript))
    return (True, o, encoded_springscript)

if __name__ == '__main__':
    prog = []
    with open('21.txt', 'r') as f:
        prog = [int(x) for x in f.read().split(',')]


    commands = ['AND', 'OR', 'NOT']
    r_regs = ['A', 'B', 'C', 'D']
    r_w_regs = ['T', 'J']
    
    pp = [ 'NOT A T',
'OR T J',
'NOT B T',
'OR T J',
'NOT C T',
'OR T J',
'NOT D T',
'NOT T T',
'AND T J']
    pp += ['NOT E T', 'NOT T T', 'OR E T', 'OR H T', 'AND T J']
    pp = encode_prog(pp, w=True)
    s, o, c = try_prog(0, pp, prog)
    print(s)
    if not s:
        pass
        print(decode(o))
    
    
    sys.exit(0)
    
    ascii_lines = []
    for c in commands:
        for reg in r_regs + r_w_regs:
            for w in r_w_regs:
                p = ' '.join([c, reg, w])
                ascii_lines += [p]
                #print(p)

    prog_len = 4
    all_prog = [[x] for x in ascii_lines]
    for x in range(prog_len-1):
        next_ = [] 
        for i, p in enumerate(all_prog):
            for a in ascii_lines:
                next_.append(p + [a])
        all_prog = next_.copy()

    #print(len(all_prog))
    
    encoded_prog = map(encode_prog, all_prog)
    args = zip(encoded_prog, repeat(prog))
    args = [(i, *x) for i, x in enumerate(args)]
    #print(args[0][:-1])
    
    pool = Pool(8)
    r = pool.starmap(try_prog, args)
    r = list(filter(lambda x: x[0], r))
    print('results')
    for res in r:
        print(res)

    sys.exit(0)

    for p in all_prog:
        e = encode_prog(p)
        print(p, e)
        c = Intcode(prog[:])
        o = c.run(input_list=e)
        #print(o)
        if o[-1] < 100:
            s = ''.join([chr(x) for x in o])
            print(s)
        else:
            print(o)
            break
        #break
        print('----')