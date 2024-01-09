
fn = "d15.txt"
#fn = "d15_test.txt"

with open(fn, 'r') as f:
    data = f.read().split(',')


print(data)

# Part 1
def HASH(s):
    characters = list(s)
    ascii = list(map(lambda x: ord(x), characters))
    r = 0
    for a in ascii:
        r += a
        r = (r * 17) % 256
    return r

numbers = list(map(lambda x: HASH(x), data))

s = sum(numbers)
print(s)

from collections import defaultdict
boxes = defaultdict(list)

for d in data:

    if d[-1] == '-':
        label = d[:-1]
        hash = HASH(label)
        print(hash)
        lenses = boxes[hash]
        lenses = [(a, b) for a, b in lenses if a != label]
    elif d[-2] == '=':
        label = d[:-2]
        hash = HASH(label)
        print(hash)
        lenses = boxes[hash]
        focal_length = int(d[-1])
        if len(list(filter(lambda x: x[0] == label, lenses))) == 0:
            lenses.append((label, focal_length))
        else:
            lenses = [(a, b) if a != label else (a, focal_length) for a, b in lenses]
    else:
        raise Exception("Unknown operation")
    
    boxes[hash] = lenses

print(boxes)

total = 0
for k, v in boxes.items():
    if v == []:
        continue
    for i, vv in enumerate(v):
        power = (k + 1) * (i + 1) * vv[1]
        print(power)
        total += power
print(total)