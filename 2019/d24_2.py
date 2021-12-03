from enum import Enum

class Position(Enum):
    North = 0
    South = 1
    West = 2
    East = 3

t_0 = """....#
#..#.
#.?##
..#..
#...."""

t_x = """#####
.#.##
#...#
..###
#.##."""

grid_eris = []
with open('24.txt', 'r') as f:
    grid_eris = [list(x) for x in f.read().split('\n')]
    
def to_str(grid):
    r = ''
    for l in grid:
        r += ''.join(l)
    return r

def print_(grid):
    for l in grid:
        print(''.join(l))

def gen_outer(grid):
    n_grid = [list('.'*5) for y in range(5)]
    
    s = sum([1 if grid[0][x]=='#' else 0 for x in range(5)])
    if 1 <= s <= 2:
        n_grid[1][2] = '#'
    s = sum([1 if grid[-1][x]=='#' else 0 for x in range(5)])
    if 1 <= s <= 2:
        n_grid[3][2] = '#'
        
    s = sum([1 if grid[y][0]=='#' else 0 for y in range(5)])
    if 1 <= s <= 2:
        n_grid[2][1] = '#'
    s = sum([1 if grid[y][-1]=='#' else 0 for y in range(5)])
    if 1 <= s <= 2:
        n_grid[2][3] = '#'
    return n_grid

def gen_inner(grid):
    n_grid = [list('.'*5) for y in range(5)]
    
    n = False
    s = False
    e = False
    w = False
    if grid[1][2] == '#':
        n = True
    if grid[3][2] == '#':
        s = True
    if grid[2][1] == '#':
        w = True
    if grid[2][3] == '#':
        e = True
    for x in range(5):
        if n:
            n_grid[0][x] = '#'
        if s:
            n_grid[-1][x] = '#'
    for y in range(5):
        if n:
            n_grid[y][0] = '#'
        if s:
            n_grid[y][-1] = '#'
    return n_grid

def edge_sum(grid, pos):    
    if pos == Position.North:
        return sum([1 if grid[0][x]=='#' else 0 for x in range(5)])
    if pos == Position.South:
        return sum([1 if grid[-1][x]=='#' else 0 for x in range(5)])
    if pos == Position.West:
        return sum([1 if grid[y][0]=='#' else 0 for y in range(5)])
    if pos == Position.East:
        return sum([1 if grid[y][-1]=='#' else 0 for y in range(5)])
    raise ValueError('Unable to compute edge sum for: {}'.format(pos))

def get_dir(x, y):
    if x == 2 and y == 1:
        return Position.North
    if x == 2 and y == 3:
        return Position.South
    if x == 1 and y == 2:
        return Position.West
    if x == 3 and y == 2:
        return Position.East
    else:
        print(x, y)
        raise ValueError('Unknown pos')

def print_grids(grids):
    for i, grid in grids:
        print('depth', i)
        for line in grid:
            print(''.join(line))
        print('----')
    
def simulate_recursive(grids, iterations):
    for i in range(1, iterations+1):
        
        n_grids = []
        new_outer = gen_outer(grids[0][1])
        if sum([1 if x == '#' else 0 for l in new_outer for x in l]) > 0:
            n_grids += [(grids[0][0]-1, new_outer)]
        print('Iteration', i, len(grids))
        #print_grids(grids)
        for i, (depth, grid) in enumerate(grids):            
            prev = grids[i-1][1]
            n_grid = [list('.'*5) for y in range(5)]
            n_grid[2][2] = '?'
            for y in range(5):
                for x in range(5):
                    if y == 2 and x == 2:
                        continue
                    adj = 0
                    for ny, nx in [(y-1, x), (y+1, x), (y, x-1), (y, x+1)]:
                        if nx < 0 and i > 0:
                            adj += 1 if prev[2][1] == '#' else 0
                        elif nx >= 5 and i > 0:
                            adj += 1 if prev[2][3] == '#' else 0
                        if ny < 0 and i > 0:
                            adj += 1 if prev[1][2] == '#' else 0
                        elif ny >= 5 and i > 0:
                            adj += 1 if prev[3][2] == '#' else 0  
                        elif (nx, ny) == (2, 2) and i < len(grids)-1:
                            d = get_dir(x, y)
                            r = edge_sum(grids[i+1][1], d)
                            adj += r
                        elif 0 <= ny < 5 and 0 <= nx < 5:
                            adj += 1 if grid[ny][nx] == '#' else 0
                    tile = grid[y][x]
                    if tile == '#' and adj != 1:
                        n_grid[y][x] = '.'
                    elif tile == '.' and 1 <= adj <= 2:
                        n_grid[y][x] = '#'
                    else:
                        n_grid[y][x] = grid[y][x]
            n_grids += [(depth, n_grid)]
            
        new_inner = gen_inner(grids[-1][1])
        if sum([1 if x == '#' else 0 for l in new_inner for x in l]) > 0:
            n_grids += [(grids[-1][0]+1, new_inner)]
            
        grids = n_grids
        #break
    return grids


grid = [list(x) for x in t_0.split('\n')]
grids = [(0, grid)]
#res = simulate_recursive(grids, 10)

grid = [list(x) for x in t_x.split('\n')]
grids = [(0, grid)]
res = simulate_recursive(grids, 200)

#grids = [(0, grid_eris)]
#res = simulate_recursive(grids, 201)
print('Result:')
print_grids(res)

s = sum([1 if x == '#' else 0 for (d, grid) in res for l in grid for x in l])
print('Sum: ', s)