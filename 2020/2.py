
def range_helper(s):
    r = s.split('-')
    return (int(r[0]), int(r[1]))

def row_helper(row):
    min_, max_ = range_helper(row[0])
    c = row[1][0]
    return (min_, max_, c, row[2])

def is_valid_pwd(tpl):
    count = tpl[3].count(tpl[2])
    if count >= tpl[0] and count <= tpl[1]:
        return True
    return False

def is_valid_pwd_2(tpl):
    c = tpl[2]
    first_pos = tpl[0]-1
    last_pos = tpl[1]-1
    p1 = tpl[3][first_pos] == c and tpl[3][last_pos] != c
    p2 = tpl[3][first_pos] != c and tpl[3][last_pos] == c
    return (p1 and not p2) or (p2 and not p1)
    
with open('2.txt', 'r') as f:
    data = [x.strip().split(' ') for x in f.readlines()]
    data = list(map(lambda x: row_helper(x), data))

    p1 = len(list(filter(is_valid_pwd, data)))
    print(p1)

    p2 = len(list(filter(is_valid_pwd_2, data)))
    print(p2)
    
    #p2 = list(map(lambda x: (is_valid_pwd_2(x), x[3]), data))
    #print(p2)
