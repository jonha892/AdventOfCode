from d15_pathfinder import Pathfinder

with open('15.txt', 'r') as f:
    prog = [int(x) for x in f.read().split(',')]
    p = Pathfinder(prog)
    p.fill_with_oxigen()