from enum import Enum
import re

from intcode_11 import Intcode

class Direction(Enum):
    Left = 0
    Right = 1
    Top = 2
    Bot = 3
        

class Map:
    def __init__(self, prog, with_print=True):
        self.prog = prog[:]
        self.c = Intcode(prog[:])
        self.m = []
        self.read_map(with_print=with_print)
    
    def reset(self):
        self.c = Intcode(self.prog[:])
        self.m = []
        self.read_map(False)
    
    def read_map(self, with_print):
        outputs = self.c.run()
        line = ''
        for o in outputs:
            if o == 10:
                if with_print:
                    print(line)
                if len(line) > 0:
                    self.m.append(list(line))
                line = ''
                continue
            c = chr(o)
            line += c
    
    def _print(self):
        for l in self.m:
            s = ''.join(l)
            print(s)
    
    def find_start(self):
        for y in range(1, len(self.m)):
            for x in range(1, len(self.m[0])):
                if self.m[y][x] == '>':
                    return (x, y), Direction.Right
                elif self.m[y][x] == '<':
                    return (x, y), Direction.Left
                elif self.m[y][x] == '^':
                    return (x, y), Direction.Top
                elif self.m[y][x] == 'v':
                    return (x, y), Direction.Bot                
        raise ValueError('no start found')
        
    def move(x, y, d):
        if d == Direction.Right:
            return x+1, y
        elif d == Direction.Left:
            return x-1, y
        elif d == Direction.Top:
            return x, y-1
        elif d == Direction.Bot:
            return x, y+1
        else:
            raise ValueError('unknown direction')
            
    def allowed_pos(self, x, y):
        #print(x, y, self.m[y][x])
        if y < 0 or y >= len(self.m):
            return False
        elif x < 0 or x >= len(self.m[y]):
            return False
        elif self.m[y][x] == '#' or self.m[y][x] == 'O':
            return True
        return False
    
    def new_dir(self, x, y, d):
        if d == Direction.Right or d == Direction.Left:
            p1 = self.allowed_pos(x, y-1)
            p2 = self.allowed_pos(x, y+1)
            
            if p1 and p2:
                raise ValueError('Two directions possible')
            elif p1:
                return Direction.Top
            elif p2:
                return Direction.Bot
        elif d == Direction.Top or d == Direction.Bot:
            p1 = self.allowed_pos(x-1, y)
            p2 = self.allowed_pos(x+1, y)
            #print(p1, p2, x, y)
            if p1 and p2:
                raise ValueError('Two directions possible')
            elif p1:
                return Direction.Left
            elif p2:
                return Direction.Right
        else:
            raise ValueError('Unknown direction')
        return -1
    
    def find_paths(self):
        start, d = self.find_start()
        px = start[0]
        py = start[1]
        
        vectors = []
        current_length = 0
        i = 0
        while True:
            #print('Iteration: ', i)
            if i > 20:
                pass
                #return vectors
            nx, ny = Map.move(px, py, d)
            if not self.allowed_pos(nx, ny):
                if current_length > 0:
                    vectors.append((d, current_length))
                    current_length = 0
                d = self.new_dir(px, py, d)
                if d == -1:
                    print('Found end at: ', px, py)
                    return vectors
            else:
                current_length += 1
                px = nx
                py = ny
            i += 1
            
    def turn(a, b):
        if a == Direction.Right:
            if b == Direction.Top:
                return 'L'
            elif b == Direction.Bot:
                return 'R'
        if a == Direction.Left:
            if b == Direction.Top:
                return 'R'
            elif b == Direction.Bot:
                return 'L'
        if a == Direction.Top:
            if b == Direction.Right:
                return 'R'
            elif b == Direction.Left:
                return 'L'
        if a == Direction.Bot:
            if b == Direction.Right:
                return 'L'
            elif b == Direction.Left:
                return 'R'
        return ValueError('unknown dir combo')
    
    def walk_string(remaining, patterns, result, result_map):
        if len(remaining) == 0:
            result_map[result] = True
            return
        print(patterns, remaining, result)
        for j, p in enumerate(patterns.keys()):
            #print(remaining, p, patterns[p], 'res', result)
            if remaining.startswith(p):
                r = result + patterns[p]
                Map.walk_string(remaining[len(p):], patterns, r, result_map)
        #result[i] = (False, result)
        
    def part_2(self):
        paths = self.find_paths()
        print(paths)
        prog = []
        tmp, prev_d = self.find_start()
        for (d, l) in paths:
            t = Map.turn(prev_d, d)
            prog += [t, l]
            prev_d = d
        prog_s = ''.join(map(str, prog))
        
        prog_lst = [str(x) for x in prog]
        prog = [ord(x) for x in prog_s] + [10]
        
        res = {}
        example = 'L6L4R8R8L6L4L10R8L6L4R8L4R4L4R8R8L6L4L10R8L4R4L4R8R8L6L4L10R8L4R4L4R8L6L4R8R8L6L4L10R8'
        patterns = {'R8L6L4L10R8': 'A', 'L6L4R8': 'B', 'L4R4L4R8': 'C'}
        patterns_2 = [['R', '8', 'L', '6', 'L', '4', 'L', '10', 'R', '8'], ['L', '6', 'L', '4', 'R', '8'], ['L', '4', 'R', '4', 'L', '4', 'R', '8']]
        Map.walk_string(example, patterns, '', res)
        print(res)
        programs = []
        for k in res.keys():
            programs += [[ord(x) for x in ','.join(k)] + [10]]
            break
        for p in patterns_2:      
            programs += [[ord(x) for x in ','.join(p)] + [10]]
        print(programs)
        all_input = [x for y in programs for x in y] + [10, 10]
        print(all_input)
        
        c = Intcode(self.prog[:])
        print(c.prog[0])
        c._set_addr(0, 2)
        print(c.prog[0])
        #print(c.prog, 'index', c.index)
        o = c.run(input_list=all_input)
        #o = c.run(manual_input=True)
        print(o)
        o_str = ''.join(map(lambda x: chr(x), o))
        print(sum(o))
        print(o_str)
        return
        
        print(prog_s)
        min_l = 10000
        for a in range(2, 13, 2):
            for b in range(2, 13, 2):
                for c in range(2, 13, 2):
                    #print(a, b, c)
                    patterns = {}
                    tmp = list(''.join(prog_lst))
                    a_pattern = ''.join(tmp[:a])
                    
                    tmp = list(''.join(prog_lst[a:]))
                    b_pattern = ''.join(tmp[:b])
                    
                    tmp = tmp.startswith(a_pattern)
                    c_pattern = ''.join(tmp[:c])
                    patterns[a_pattern] = 'A'
                    patterns[b_pattern] = 'B'
                    patterns[c_pattern] = 'C'
                    
                    #print(tmp)
                    tmp = ''.join(prog_lst)
                    res = {}
                    Map.walk_string(tmp, patterns, '', res)
                    if len(res.keys()) > 0:
                        for k, i in res:
                            print(a_pattern, b_pattern, c_pattern, k)
                    #print(a_pattern, b_pattern, c_pattern, res)
        
        
        
        return prog
    
    def find_intersections(self):
        length = len(self.m[0])
        assert all(len(x) == length for x in self.m)

        pos = []
        s = 0
        for y in range(1, len(self.m)-1):
            for x in range(1, len(self.m[0])-1):
                #print(len(self.m), y)
                p = self.m[y][x]
                left = self.m[y][x-1]
                right = self.m[y][x+1]
                top = self.m[y-1][x]
                bot = self.m[y+1][x]
                if all(x == '#' for x in [p, left, right, top, bot]):
                    pos.append((x, y))
                    s += x*y
                    self.m[y][x] = 'O'
        return pos, s
                
        
        
"""

                    tmp = tmp.replace(a_pattern, 'A')
                    tmp = tmp.replace(b_pattern, 'B')
                    tmp = tmp.replace(c_pattern, 'C')
                    #print(a_pattern, b_pattern, c_pattern, tmp)
                    if len(tmp) < min_l:
                        min_l = len(tmp)
                    print(a_pattern, b_pattern, c_pattern, tmp)
                    if a > 6 or b > 6 or c > 6:
                        pass
                        #return
                    if len(tmp) > 1000:
                        continue
                    elif any(x in tmp for x in ['R', 'L']):
                        continue
                    else:
                        print('found patterns A:{} B:{} C:{} - {}'.format(a_pattern, b_pattern, c_pattern, tmp))
                        break
"""