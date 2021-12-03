from enum import Enum
import time
from collections import deque
import networkx as nx

from intcode_11 import Intcode

class Feedback(Enum):
    WALL=0
    EMPTY=1
    OXYGEN=2
    
class Direction(Enum):
    NORTH=1
    SOUTH=2
    WEST=3
    EAST=4

class Pathfinder:
    def __init__(self, prog):
        self.m = {(0,0):Feedback.EMPTY }
        self.distances = { (0,0): 0 }
        self.visited = []
        self.graph = nx.Graph()
        
        self.prog = prog[:]
        self.cmp = Intcode(prog)
        
    
    def reset_pos(self):
        self.px = 0
        self.py = 0
        self.cmp = Intcode(prog[:])
       
    def add_pos(self, pos, d):
        n_px = pos[0]
        n_py = pos[1]
        
        if d == Direction.NORTH:
            n_py += 1
        elif d == Direction.SOUTH:
            n_py -= 1
        elif d == Direction.WEST:
            n_px -= 1
        elif d == Direction.EAST:
            n_px += 1
        return (n_px, n_py)
    
    def move(self, d, cmp):
        r = cmp.run(_input=d.value, output_len=1)
        assert len(r) == 1
        r = r[0]
        if r == Feedback.WALL.value:
            return Feedback.WALL
        elif r == Feedback.EMPTY.value:
            return Feedback.EMPTY
        elif r == Feedback.OXYGEN.value:
            return Feedback.OXYGEN
        else:
            raise ValueError('Unknown Intcode response: {}'.format(r))
            
    def dfs(self, pos, cost, cmp):
        if pos not in self.distances.keys():
            self.distances[pos] = cost
        elif pos in self.distances.keys() and cost < self.distances[pos]:
            self.distances[pos] = cost
        #print('dfs', pos, cost)
        self.print_maze(pos)
        time.sleep(0.1)
  
        self.visited.append(pos)
            
        for d in [Direction.NORTH, Direction.SOUTH, Direction.WEST, Direction.EAST]:
            #print('t')
            p = self.add_pos(pos, d)
            if p in self.visited:
                continue
            c = cmp.copy()
            r = self.move(d, c)
            self.m[p] = r
            if r == Feedback.WALL:
                continue
            else:
                if not self.graph.has_edge(pos, p):
                    self.graph.add_edge(pos, p)
                self.dfs(p, cost+1, c)
        return True
    
    def search_oxygen(self):
        self.dfs((0,0), 0, self.cmp.copy()) 
        for k, v in self.m.items():
            if v == Feedback.OXYGEN:
                print('Oxygen at: ', k)
                print('Cost: ', self.distances[k]) 
                r = k
        return r
    
    def fill_with_oxigen(self):
        o_pos = self.search_oxygen()
        r = nx.single_source_shortest_path_length(self.graph, o_pos)
        print(r)
        print(max(r.values()))

    def print_maze(self, pos):
        keys = list(self.m.keys())
        minx = min(keys, key=lambda x: x[0])[0]
        maxx = max(keys, key=lambda x: x[0])[0]
        miny = min(keys, key=lambda x: x[1])[1]
        maxy = max(keys, key=lambda x: x[1])[1]
        #print(self.m)
        for y in range(maxy, miny-1, -1):
            r = ''
            for x in range(minx, maxx+1):
                if x == pos[0] and y == pos[1]:
                    r += 'D'
                elif (x, y) in keys:
                    v = self.m[(x, y)]
                    if v == Feedback.WALL:
                        r += '#'
                    elif v == Feedback.EMPTY:
                        r += '.'
                    elif v == Feedback.OXYGEN:
                        r += 'O'
                else:
                    r += ' '
            print(r)
        print(''*50)