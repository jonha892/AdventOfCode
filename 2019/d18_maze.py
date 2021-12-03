from enum import Enum
import collections
import itertools

import sortedcollections
import networkx as nx
    
class Direction(Enum):
    NORTH=1
    SOUTH=2
    WEST=3
    EAST=4

class Maze:
    def __init__(self, maze_txt):
        self.maze = []
        self.txt = maze_txt[:]
        self.read_maze()
        
    def read_maze(self):
        for l in self.txt.split('\n'):
            self.maze += [list(l)]
        length = len(self.maze[0])
        assert all(len(x) == length for x in self.maze)
    
    def print_maze(maze):
        for l in maze:
            print(''.join(l))
        
    def new_pos(pos, d):
        n_px = pos[0]
        n_py = pos[1]
        
        if d == Direction.NORTH:
            n_py -= 1
        elif d == Direction.SOUTH:
            n_py += 1
        elif d == Direction.WEST:
            n_px -= 1
        elif d == Direction.EAST:
            n_px += 1
        return (n_px, n_py)
    
    def allowed_pos(maze, pos):
        x = pos[0]
        y = pos[1]
        if x < 0 or x >= len(maze[0]):
            return False
        if y < 0 or y >= len(maze):
            return False
        return True
            
    def reachable_keys(maze, start, have_keys):
        bfs = collections.deque([start])
        distance = {start: 0}
        keys = {}
        #Maze.print_maze(maze)
        while bfs:
            pos = bfs.popleft()
            #print(pos)
            for d in [Direction.NORTH, Direction.SOUTH, Direction.EAST, Direction.WEST]:
                next_pos = Maze.new_pos(pos, d)
                if not Maze.allowed_pos(maze, next_pos):
                    continue
                
                nx = next_pos[0]
                ny = next_pos[1]
                tile = maze[ny][nx]
                if tile == '#':
                    continue
                if next_pos in distance:
                    continue
                distance[next_pos] = distance[pos] + 1
                if 'A' <= tile <= 'Z' and tile.lower() not in have_keys:
                    continue
                if 'a' <= tile <= 'z' and tile not in have_keys:
                    keys[tile] = distance[next_pos], next_pos
                else:
                    bfs.append(next_pos)
        return keys
    
    def reachable4(maze, starts, have_keys):
        keys = {}
        for i, start in enumerate(starts):
            for k, (dist, pos) in Maze.reachable_keys(maze, start, have_keys).items():
                keys[k] = dist, pos, i
        return keys


    def minwalk(maze, starts, have_keys, seen):
        #Maze.print_maze(maze)
        #print(starts, have_keys, seen)
        hks = ''.join(sorted(have_keys))
        if (starts, hks) in seen:
            return seen[starts, hks]
        if len(seen) % 10 == 0:
            print(hks)
        keys = Maze.reachable4(maze, starts, have_keys)
        #print(len(maze), len(maze[0]))
        #print('reachable keys: ', keys)
        #return
        if len(keys) == 0:
            # done!
            ans = 0
        else:
            poss = []
            for k, (dist, pos, roi) in keys.items():
                nstarts = tuple(pos if i == roi else p for i, p in enumerate(starts))
                #print('new starts', nstarts)
                poss.append(dist + Maze.minwalk(maze, nstarts, have_keys + k, seen))
            ans = min(poss)
        seen[starts, hks] = ans
        return ans
                
    def solve(self):
        starts = []
        for y, line in enumerate(self.maze):
            for x, field in enumerate(line):
                if field == '@':
                    start = (x, y)
                    #print('start: ', start)
                    starts.append(start)
        maze = self.maze.copy()
        #Maze.print_maze(maze)
        print('start', starts)
        print(Maze.minwalk(maze, tuple(starts), '', {}))
        
        
        