from enum import Enum
import itertools

import networkx as nx
    
class Direction(Enum):
    NORTH=1
    SOUTH=2
    WEST=3
    EAST=4

class Maze:
    def __init__(self, maze_txt):
        self.maze = []
        self.distances = { (0,0): 0 }
        self.doors = {}
        self.all_keys = { }
        self.new_keys = {}
        self.visited = []
        self.graph = nx.Graph()
        
        self.txt = maze_txt[:]
        self.read_maze()
        
    def read_maze(self):
        for l in self.txt.split('\n'):
            self.maze += [list(l)]
        length = len(self.maze[0])
        assert all(len(x) == length for x in self.maze)
    
    def print_maze(self):
        for l in self.maze:
            print(''.join(l))
        
    def new_pos(self, pos, d):
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
    
    def check_pos(self, pos, block_on_key=False):
        x = pos[0]
        y = pos[1]
        if x < 0 or x >= len(self.maze[0]):
            return False
        if y < 0 or y >= len(self.maze):
            return False
        field = self.maze[y][x]
        if field == '#':
            return False
        elif field.isupper():
            print('block on door', x, y, field)
            self.doors[pos] = field
            return False
        if field.islower():
            if block_on_key:
                print('block on key', x, y, field)
                return False
            self.maze[y][x] = '.'
            self.all_keys[pos] = field
            self.new_keys[pos] = field
        return True
            
    def dfs(self, prev_pos, pos, cost, block_on_key=False):
        if pos in self.visited:
            return
        self.visited.append(pos)
        r = self.check_pos(pos, block_on_key=block_on_key)
        if not r:
            return
        else:
            if not self.graph.has_edge(prev_pos, pos) and prev_pos != pos:
                self.graph.add_edge(prev_pos, pos)
                    
        if pos not in self.distances.keys():
            self.distances[pos] = cost
        elif pos in self.distances.keys() and cost < self.distances[pos]:
            self.distances[pos] = cost
        #print('dfs', pos, cost)
        
        #self.print_maze(pos)
        #time.sleep(0.1)   
        for d in [Direction.NORTH, Direction.SOUTH, Direction.WEST, Direction.EAST]:
            #print('t')
            next_pos = self.new_pos(pos, d)
            self.dfs(pos, next_pos, cost+1, block_on_key=block_on_key)

    def reset(self):
        self.doors = {}
        self.new_keys = {}
        self.visited = []
        
    def shortest_paths(self, source, targets):
        if len(targets) == 0:
            return [[source]]
        paths = []
        perm = list(itertools.permutations(targets))
        t = list(map(lambda x: self.all_keys[x], targets))
        print('Shortest path permuatations', len(perm))
        #print('Shortest paths for source: {} and target permulations: {}'.format(self.all_keys[source], t))
        for i, p in enumerate(perm):
            path = [source]
            print(i)
            for t in p:
                r = nx.shortest_path(self.graph, source=path[-1], target=t)
                path += r[1:]
            paths += [path]
        #print('=> ', paths)
        return paths
    
    def solve(self):
        start = (-1, -1)
        for y, line in enumerate(self.maze):
            for x, field in enumerate(line):
                if field == '@':
                    start = (x, y)
                    print('start: ', start)
                    break
        self.all_keys[start] = '@'
        paths = [[start]]
        old_keys = []
        while True:
            self.dfs(start, start, 0)
            #print(self.graph.edges())
                #print(p)
            
            print('Doors:', self.doors)
            print('All Keys:', self.all_keys)
            while True:
                opened_door = False
                for (dx, dy), field in self.doors.items():
                    key = field.lower()
                    del_keys = []
                    for pos, k in self.all_keys.items():
                        if key == k and self.maze[dy][dx].isupper(): 
                            print('Open door {} at {}'.format(field, (dx, dy)))
                            self.maze[dy][dx] = '.'
                            del_keys += [pos]
                            opened_door = True
                            break
                if opened_door:
                    print('Searching for additional doors...')
                    self.visited = []
                    self.print_maze()
                    self.dfs(start, start, 0, block_on_key=True)
                    #print(self.doors)
                else:
                    break
                    
                    
            print('New keys', self.new_keys)
            print('current path length + new keys length', len(paths), len(self.new_keys.keys()))
            next_paths = []
            for p in paths:
                new_paths = self.shortest_paths(p[-1], list(self.new_keys.keys()))
                for n in new_paths:
                    next_paths.append(p + n[1:])
                #print('key: {} pos: {} shortest path: {}'.format(k, pos, len(path), path))
            print('paths: ', len(next_paths))
            paths = next_paths
            for p in paths:
                pass            
            self.print_maze()
            
            
            if len(self.new_keys.keys()) == 0:
                print('all keys found')
                self.print_maze()
                break
                
            self.reset()
        lengths = [len(x)-1 for x in paths]
        m = min(lengths)
        i = lengths.index(m)
        
        print('Keys:', self.all_keys)
        print('Result: ', m)
        print(paths[i])
        for p in paths:
            lst_of_keys = []
            for n in p:
                if n in self.all_keys.keys():
                    k = self.all_keys[n]
                    if k not in lst_of_keys:
                        lst_of_keys.append(k)
            print(lst_of_keys, len(p))