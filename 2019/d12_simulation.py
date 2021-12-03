import math

def lcm(a, b):
    return abs(a*b) // math.gcd(a, b)

class Object:
    def __init__(self, _id,  x, y, z):
        self._id = _id
        self.x = x
        self.y = y
        self.z = z
        self.vel_x = 0
        self.vel_y = 0
        self.vel_z = 0
        
    def adjust_velocity(self, others):
        dx = 0
        dy = 0
        dz = 0
        for o in others:
            if o._id == self._id:
                continue
            if self.x < o.x:
                dx += 1
            elif self.x > o.x:
                dx -= 1
            if self.y < o.y:
                dy += 1
            elif self.y > o.y:
                dy -= 1
            if self.z < o.z:
                dz += 1
            elif self.z > o.z:
                dz -= 1
        self.vel_x += dx
        self.vel_y += dy
        self.vel_z += dz
        
    def adjust_pos(self):
        self.x += self.vel_x
        self.y += self.vel_y
        self.z += self.vel_z
        
    def _print_state(self):
        s_0 = 'pos=<x={:>3}, y={:>3}, z={:>3}>, '.format(self.x, self.y, self.z)
        s_1 = 'vel=<x={:>3}, y={:>3}, z={:>3}>'.format(self.vel_x, self.vel_y, self.vel_z)
        print(s_0 + s_1)
        
    def get_energy(self, p=False):
        pot = abs(self.x) + abs(self.y) + abs(self.z)
        kin = abs(self.vel_x) + abs(self.vel_y) + abs(self.vel_z)
        total = pot*kin
        if p == True:
            s_0 = 'pot: {:>3} + {:>3} + {:>3} =  {:>4}; '.format(abs(self.x), abs(self.y), abs(self.z), pot)
            s_1 = 'kin: {:>3} + {:>3} + {:>3} = {:>4}; '.format(abs(self.vel_x), abs(self.vel_y), abs(self.vel_z), kin)
            s_2 = 'total:  {:>4} * {:>4} = {:>4}'.format(pot, kin, total)
            print(s_0 + s_1 + s_2)
        return total
    
    def state_string(self):
        return '{}{}{}{}{}{}'.format(self.x, self.y, self.z, self.vel_x, self.vel_y, self.vel_z)
        
class SingleDimObject:
    def __init__(self, _id, p, v):
        self._id = _id
        self.pos = p
        self.vel = v
    
    def adjust_velocity(self, others):
        d = 0
        for o in others:
            if o._id == self._id:
                continue
            if self.pos < o.pos:
                d += 1
            elif self.pos > o.pos:
                d -= 1
        self.vel += d
        
    def adjust_pos(self):
        self.pos += self.vel
        
    def state_string(self):
        return '{}{}'.format(self.pos, self.vel)
    
class Simulation:
    def __init__(self, lst):
        self.objects = []
        for i, (x, y, z) in enumerate(lst):
            self.objects.append(Object('Object' + str(i), x, y, z))
            
    def print_state(self, i):
        print('State after {}:'.format(i))
        for o in self.objects:
            o._print_state()
            
    def print_energy(self, i, print_individual=True):
        print('Energy after {}:'.format(i))
        t = []
        for o in self.objects:
            tmp = o.get_energy(p=print_individual)
            t.append(tmp)
        sum_s = ' + '.join(map(str, t))
        s = sum(t)
        print('Sum of total energy: {} = {}'.format(sum_s, s))
    
    def simulate(self, iterations, print_state=True):
        if print_state:
            self.print_state(0)
        for i in range(1, iterations+1):
            for o in self.objects:
                o.adjust_velocity(self.objects)
            for o in self.objects:
                o.adjust_pos()
               
            if print_state:
                self.print_state(i)
                
        self.print_energy(iterations - 1, print_individual=True)
        
    def simulate_until_repitition(self):
        memory = {}
        i = 0
        while True:
            for o in self.objects:
                o.adjust_velocity(self.objects)
            for o in self.objects:
                o.adjust_pos()
                
            state = ''
            for o in self.objects:
                state += o.state_string()
            if state in memory:
                print('repitition found after ', i - memory[state], ' steps')
                return
            else:
                memory[state] = i
                i += 1
    
    def single_dim_repition(self, objects):
        memory = {}
        i = 0
        while True:
            for o in objects:
                o.adjust_velocity(objects)
            for o in objects:
                o.adjust_pos()
                
            state = ''
            for o in objects:
                state += o.state_string()
            if state in memory:
                r = i - memory[state]
                print('repitition found after ', r, ' steps')
                return r
            else:
                memory[state] = i
                i += 1
    
    def simulate_until_repitition_fast(self):
        # X
        x_dim_objects = []
        for o in self.objects:
            x_dim_objects.append(SingleDimObject(o._id, o.x, o.vel_x))
        repetition_x = self.single_dim_repition(x_dim_objects)
        
        # Y
        y_dim_objects = []
        for o in self.objects:
            y_dim_objects.append(SingleDimObject(o._id, o.y, o.vel_y))
        repetition_y = self.single_dim_repition(y_dim_objects)
        
        # Z
        z_dim_objects = []
        for o in self.objects:
            z_dim_objects.append(SingleDimObject(o._id, o.z, o.vel_z))
        repetition_z = self.single_dim_repition(z_dim_objects)
        
        print(repetition_x, repetition_y, repetition_z)
        
        answer = lcm(repetition_x, lcm(repetition_y, repetition_z))
        print(answer)