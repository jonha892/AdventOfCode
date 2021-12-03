
from intcode_23 import Intcode



nic = []
with open('23.txt', 'r') as f:
    nic = [int(x) for x in f.read().split(',')]

network = []
for id_ in range(50):
    c = Intcode(nic[:], id_)
    network.append(c)
    
finished = False
prev_nat_message = (-1, -1, -1)
nat_message = None
while True:
    messages = []
    idles = []
    for c in network:
        c.run(stepwise=True, with_queue=True)
        if len(c.out_queue) > 0 and len(c.out_queue) % 3 == 0:
            m = tuple([c.out_queue.popleft() for x in range(3)])
            if m[0] == 255:
                #print(m)
                #finished = True
                nat_message = m
            else:
                messages.append(m)
        idles.append(c.is_idle())
    if nat_message is not None and all(idles):
        if nat_message[2] == prev_nat_message[2]:
            print(nat_message, prev_nat_message)
            break
        else:
            print('Restarting with: ', nat_message)
            prev_nat_message = nat_message
        network[0].in_queue.append((nat_message[1], nat_message[2]))
        nat_message = None
    for (r, x, y) in messages:
        assert 0 <= r < 50
        network[r].in_queue.append((x, y))
    