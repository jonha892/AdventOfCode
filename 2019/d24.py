t_0 = """....#
#..#.
#..##
..#..
#...."""


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

def simulate(grid):
    d_y = len(grid)
    d_x = len(grid[0])
    
    n_grid = [list('.'*d_x) for y in range(d_y)]
    
    for y in range(d_y):
        for x in range(d_x):
            adj = 0
            adj_1 = 0
            adj_2 = 0
            
            for n in [y-1, y+1]:
                if 0 <= n < len(grid):
                    adj_1 += 1 if grid[n][x] == '#' else 0
            for n in [x-1, x+1]:
                if 0 <= n < len(grid[0]):
                    adj_2 += 1 if grid[y][n] == '#' else 0
            tile = grid[y][x]
            adj = adj_1 + adj_2
            #print(y*d_y+x, adj, adj_1, adj_2)
            if tile == '#' and adj != 1:
                n_grid[y][x] = '.'
            elif tile == '.' and 1 <= adj <= 2:
                n_grid[y][x] = '#'
            else:
                n_grid[y][x] = grid[y][x]
    return n_grid

def score(grid):
    i = 0
    score = 0
    for l in grid:
        for e in l:
            if e == '#':
                score += 2**i
            i += 1
    return score

grid = [list(x) for x in t_0.split('\n')]
grid = grid_eris
memory = {}
i = 0
while True:
    key = to_str(grid)
    print_(grid)
    print('-----')
    if key in memory:
        print('Repetition after iteration: ', i)
        print('Score: ', memory[key])
        break
    else:
        memory[key] = score(grid)
    grid = simulate(grid)
    i += 1
    if i > 1:
        pass
        #break