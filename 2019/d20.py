from collections import deque
import networkx as netx

import sys

"""
portal hat 4 properties pos (verbindung zur maze) - id, parner_id
zu jedem potal 
"""

def read_maze(maze_file):
    maze_txt = ''
    with open(maze_file, 'r') as f:
        maze_txt = f.read().split('\n')
    maze = {}
    portals = {}
    port = []
    print(len(maze_txt))
    if maze_txt == '':
        raise ValueError('Error while reading maze')
    x_lim = len(maze_txt[0])
    assert all([len(x) == x_lim for x in maze_txt])
    y_lim = len(maze_txt)
    for i, line in enumerate(maze_txt):
        print('{:2} {}'.format(i, line))
        for j, c in enumerate(line):
            maze[(j, i)] = c
            if 'A' <= c <= 'Z':
                port.append(((j, i), c))
    
    #print('Portal keys: ', port)
    for (x, y), c in port:
        t = 0
        #print('...checking ', c)
        for (xx, yy) in [(x-1, y), (x+1, y),
                         (x, y-1), (x, y+1)]:
            if (xx, yy) in maze and maze[(xx, yy)] == '.':
                t += 1
                #print('portal entrence', (xx, yy))
                for (a, b) in [(x-1, y), (x+1, y),
                               (x, y-1), (x, y+1)]:
                    if (a, b) in maze and 'A' <= maze[(a, b)] <= 'Z':
                        cc = maze[(a, b)]
                        inner = True
                        if x-5 < 0 or x+5 > x_lim or y-5 < 0 or y+5 > y_lim:
                            inner = False
                        if x < a:
                            id_ = c + cc
                        elif x > a:
                            id_ = cc + c
                        elif y < b:
                            id_ = c + cc
                        elif y > b:
                            id_ = cc + c
                        else:
                            raise ValueError('Unable to build portal id')
                        portals[(x, y)] = ((xx, yy), id_, inner)
                        print('portal: ', (x, y), portals[(x, y)])
                        
    return maze, portals

def end_pos(portals):
    for (a, b), (ee, id_, i) in portals.items():
        #if ss == 'A' and tt == 'A':
        if id_ == 'ZZ':
            return ee
    raise ValueError('No end portal found')
    
def start_pos(maze, portals):
    #print('maze height', len(maze))
    keys = list(maze.keys())
    maxx = max(keys, key=lambda x: x[0])[0]
    maxy = max(keys, key=lambda x: x[1])[1]
    
    for (a, b), (ee, id_, i) in portals.items():
        #if ss == 'A' and tt == 'A':
        if id_ == 'AA':
            starts = []
            if a == 1:
                starts = [(a+1, b), (a, b-1), (a, b+1)]
            elif a == maxx-1:
                starts = [(a-1, b), (a, b-1), (a, b+1)]
            elif b == 1:
                starts = [(a, b+1), (a-1, b), (a+1, b)]
            elif b == maxy-1:
                starts = [(a, b-1), (a-1, b), (a+1, b)]
            return ee
            #print('Starts: ', starts)
            #return starts

def is_portal(p, pp, maze, portals):
    px = p[0]
    py = p[1]
    x = pp[0]
    y = pp[1]
    return maze[(px, py)] == '.' and (x, y) in portals

def is_end(pp, d, portals):
    ee, id_, i = portals[pp]
    if id_ == 'ZZ' and d == 0:
        return True
    return False

def part_1(costs, portals):
    #print('costs', costs)
    found = False
    for (a, b), (ee, id_, i) in portals.items():
        if id_ == 'ZZ':
            p = [ee]
            if a == ee[0]:
                p = [(a-1, b), (a+1, b)]
                if b < ee[1]:
                    p += [(a-1, b-1), (a+1, b-1)]
                else:
                    p += [(a-1, b+1), (a+1, b+1)]
            elif b == ee[1]:
                p = [(a, b-1), (a, b+1)]
                if a < ee[0]:
                    p += [(a-1, b-1), (a-1, b+1)]
                else:
                    p += [(a+1, b-1), (a-1, b+1)]
                
            for pos in p:
                if (pos[0], pos[1], 0) in costs:
                    print(pos, costs[(pos[0], pos[1], 0)])
            found = True
    if not found:
        print('Final portal ZZ not found')
    
    
def walk_portal(x, y, portals):
    (e, id_, i) = portals[(x, y)]
    pos = []
    for (a, b), (ee, idd_, inner) in portals.items():
        #if s == tt and e != ee:
        #    print('Portal1 available: {} {}{}:{}{} {}'.format((x, y), s, t, ss, tt, ee))
        #    pos.append(ee)   
        if id_ == idd_:
        #if s == ss and t == tt or s == tt and t == ss: #and e != ee:
            print('Portal1 available: {} {}:{} {}'.format((x, y), id_, idd_, ee))
            #print('Portal1 available: {} {}{}:{}{} {}'.format((x, y), s, t, ss, tt, ee))
            change = 1 if inner else -1
            if e == ee:
                change = 0
            pos.append((ee, change))
        """
        if t == zz:
            print('Took portal1: {} {}{}:{}{} {}'.format((x, y), s, t, ss, tt, ee))
            return ee[0], ee[1]
        elif s == ss and t == tt and e != ee:
            print('Took portal2: {} {}{}:{}{} {}'.format((x, y), s, t, ss, tt, ee))
            if s == 'Z':
                print('Took final portal')
            return ee[0], ee[1]
        """
    if len(pos) == 1:
        print('Only one portal found for: {} {}'.format((x, y), id_))
    return pos

def bfs(maze, portals, start):
    visited = {}
    start_list = [(start, 0, 0)]
    queue = deque(start_list)
    min_cost = {(start[0], start[1], 0): 0}
    graph = netx.Graph()
    while queue:
        p, cost, depth = queue.popleft()
        print(p, cost, depth)
        cost += 1
        new_positions = []
        for pp in [(p[0]-1, p[1]), (p[0]+1, p[1]),
                   (p[0], p[1]-1), (p[0], p[1]+1)]:
            if (pp[0], pp[1]) not in maze:
                #print(pp, ' not in maze')
                continue
            tile = maze[(pp[0], pp[1])]
            if tile == '#':
                #print(pp, ' is a Wall ~', tile, '~')
                continue
            if is_portal(p, pp, maze, portals):
                e, id_, i = portals[pp]
                if id_ == 'AA' or id_ == 'ZZ':
                    if depth == 0:
                        if not graph.has_edge((p[0], p[1], depth), (pp[0], pp[1], depth)):
                            graph.add_edge((p[0], p[1], depth), (pp[0], pp[1], depth))
                            if id_ == 'ZZ':
                                print('Found ZZ', pp, cost)
                                return min_cost, graph
                        continue
                n_pos = walk_portal(pp[0], pp[1], portals)
            else:
                n_pos = [(pp, 0)]
                
            for (nx, ny), change in n_pos:
                n_depth = depth + change
                e0 = (p[0], p[1], depth)
                e1 = (nx, ny, n_depth)
                if e0 != e1 and not graph.add_edge(e0, e1):
                    graph.add_edge(e0, e1)
                
                improvement = False
                
                if (nx, ny, n_depth) not in min_cost:
                    min_cost[(nx, ny, n_depth)] = cost
                    improvement = True
                elif cost < min_cost[(nx, ny, n_depth)]:
                    min_cost[(nx, ny, n_depth)] = cost
                    improvement = True
                #if depth != n_depth and (nx, ny, depth) in min_cost:
                #    continue
                if -1000 < n_depth < 3000 and improvement:
                    new_positions += [((nx, ny), cost, n_depth)]
                #print((nx, ny, depth), 'already visited')
        print('New positions', new_positions)
        queue.extend(new_positions)
    return min_cost, graph
        
maze, portals = read_maze('20.txt')

start = start_pos(maze, portals)
end = end_pos(portals)
costs, graph = bfs(maze, portals, start)

#r = graph.shortest

print('Cost to portal ZZ: ', part_1(costs, portals))

keys = list(maze.keys())
minx = min(keys, key=lambda x: x[0])[0]
maxx = max(keys, key=lambda x: x[0])[0]
miny = min(keys, key=lambda x: x[1])[1]
maxy = max(keys, key=lambda x: x[1])[1]
with open ('test.txt', 'w') as f:
    for y in range(miny, maxy+1):
        r = ''
        #break
        for x in range(minx, maxx+2):
            #break
            if (x, y) in maze:
                c = maze[(x, y)]
                if c == '.' or c == ' ':
                    if (x, y, 0) in costs:
                        r += '{:4}'.format(costs[(x, y, 0)])
                    else:
                        r += '....'
                else:
                    r += c*4
            else:
                r += '    '
        print(r)
        f.write(r + '\n')
    #print(r)