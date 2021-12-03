from d17_robots import Map

with open('17.txt', 'r') as f:
    prog = [int(x) for x in f.read().split(',')]
    m = Map(prog)
    i, s = m.find_intersections() 
    print(s)
    m._print()
    v = m.part_2()
    print(v)