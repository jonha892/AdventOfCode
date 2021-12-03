
from intcode_11 import Intcode

prog = []

with open('19.txt', 'r') as f:
    prog = [int(x) for x in f.read().split(',')]


grid = []
t = 0
for y in range(60):
    line = ''
    for x in range(60):
        c = Intcode(prog[:])
        r = c.run(input_list=[x, y])
        assert len(r) == 1
        r = r[0]
        if r == 1:
            line += '#'
            t += 1
        else:
            line += '.'
            
    grid.append(line)

for i, l in enumerate(grid):
    print('{:3} {}'.format(i, l))

""""
part 2
"""
def check(grid, cx, cy, ship_size, prog):
    #print(cx, cy, ship_end_x, ship_end_y)
    while True:
        print(cx, cy)
        ship_end_x = cx + ship_size
        ship_end_y = cy + ship_size
        
        if (cx, cy) not in grid:
            c = Intcode(prog[:])
            r = c.run(input_list=[cx, cy])
            grid[(cx, cy)] = '#' if r[0] == 1 else '.'

        if grid[(cx, cy)] != '#':
            #print(grid[(cx, cy)])
            cx += 1
            continue
            #return check(grid, cx+1, cy, ship_size, prog)
        else:
            # check x segment
            is_valid_x = True
            for x in range(cx, ship_end_x):
                if (x, cy) not in grid:
                    c = Intcode(prog[:])
                    r = c.run(input_list=[x, cy])
                    grid[(x, cy)] = '#' if r[0] == 1 else '.'
                v = grid[(x, cy)]
                if v != '#':
                    is_valid_x = False
                    break

            if is_valid_x:
                is_valid_y = True
                for y in range(cy, ship_end_y):
                    if (cx, y) not in grid:
                        c = Intcode(prog[:])
                        r = c.run(input_list=[cx, y])
                        grid[(cx, y)] = '#' if r[0] == 1 else '.'
                    v = grid[(cx, y)]
                    if v != '#':
                        is_valid_y = False
                        break
                if is_valid_y:
                    for y in range(cy, ship_end_y):
                        row = []
                        for x in range(cx, ship_end_x):
                            row += grid[(cx, cy)]
                        print(''.join(row))
                    print('found result: ')
                    return 0, cx, cy
                else:
                    cx += 1
                    continue
                    #return check(grid, cx+1, cy, ship_size, prog)
            else:
                cy += 1
                continue
                #return check(grid, cx, cy+1, ship_size, prog)
            
ship_size = 100
cx = 5
cy = 6
grid_2 = {}

r = check(grid_2, cx, cy, ship_size, prog)
print(r)
"""
def check_2(grid, cx, cy, ship_size):
    ship_end_x = cx + ship_size
    ship_end_y = cy + ship_size
    #print(cx, cy, ship_end_x, ship_end_y)
    
    if ship_end_x >= len(grid[0]) or ship_end_y >= len(grid):
        return -1, cx, cy
    
    if grid[cy][cx] != '#':
        #print(grid[cy][cx])
        return check(grid, cx+1, cy, ship_size)
    elif r == -1:
        raise ValueError('No # found')
    else:
        segment = grid[cy][cx:ship_end_x]
        #print(segment)
        if all(x == '#' for x in segment):
            y_segment = [grid[y][cx] for y in range(cy,ship_end_y)]
            
            if all(y == '#' for y in y_segment):
                return 0, cx, cy
            else:
                return check(grid, cx+1, cy, ship_size)
        else:
            return check(grid, cx, cy+1, ship_size)

while not finished:
    grid_size = 50 + grid_factor * 50
    grid_factor += 1
    while len(grid) < grid_size:
        grid += [['.'] * grid_size]
    for i, g in enumerate(grid):
        if len(g) < grid_size:
            diff = grid_size - len(g)
            grid[i] = g + ['.'] * diff
            
    print('Generating grid y from-to: {}-{} ; x from-to: {}-{}'.format(fill_index_y, grid_size, fill_index_x, grid_size))
    for y in range(fill_index_y, grid_size):
        line = []
        for x in range(fill_index_x, grid_size):
            c = Intcode(prog[:])
            r = c.run(input_list=[x, y])
            #assert len(r) == 1
            r = r[0]
            if r == 1:
                line += ['#']
            else:
                line += ['.']
                
        grid.append(line)
    fill_index_y = grid_size
    fill_index_x = grid[-1].index('#')
    print('Searching for area with size {}...'.format(ship_size))
    while True:
        state, cx, cy  = check_2(grid, cx, cy, ship_size)
        if state == -1:
            print('...Grid size too small. Increasing grid size.')
            break
        elif state == 0:
            print('...Found enough space at coordinate', cx, cy)
            print('Result: {}'.format(10000*cx + cy))
            finished = True
            break
        
        
    # Shift x
"""