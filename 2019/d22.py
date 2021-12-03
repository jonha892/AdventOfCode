import sys


t_0 = """deal with increment 7
deal into new stack
deal into new stack"""

t_1 = """cut 6
deal with increment 7
deal into new stack"""

t_2 = """deal with increment 7
deal with increment 9
cut -2"""

t_3 = """deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1"""

def shuffleing(instructions):
    r = []
    for i in instructions:
        if i == 'deal into new stack':
            r.append(('n', 0))
        elif i.startswith('deal with increment'):
            v = int(i.split(' ')[-1])
            r.append(('i', v))
        elif i.startswith('cut'):
            v = int(i.split(' ')[-1])
            r.append(('c', 0))
        else:
            raise ValueError('Unknown instruction: ' + i)
    return r

def deal_with_increment(deck, v):
    r = [-1 for d in deck]
    pos = 0
    for card in deck:
        r[pos] = card
        pos = (pos+v) % len(deck)
    return r

def deal_into_new_stack(deck):
    return deck[::-1]

def cut(deck, v):
    return deck[v:] + deck[:v]

def follow_card_inc(card_pos, deck_size, v):
    return ((card_pos) * v)  % deck_size

def folow_card_new(card_pos, deck_size):
    return deck_size - 1 - card_pos

def follow_card_cut(card_pos, deck_size, v):
    if v > 0:
        if v <= card_pos:
            return card_pos - v
        else:
            return deck_size - v + card_pos
    elif v < 0:
        v = abs(v)
        cutoff = deck_size - v
        if card_pos < cutoff:
            return card_pos + v
        else:
            return card_pos - cutoff
    return card_pos

def shuffle(deck, instructions, iterations=1):
    s_pos = -1
    for j, d in enumerate(deck):
        if d == 2019:
            s_pos = j
            break
    f_pos = 2019
    deck_size = len(deck)
    for j in range(iterations):            
        for (i, v) in instructions:        
            if i == 'n':
                deck = deal_into_new_stack(deck)
                n_f_pos = folow_card_new(f_pos, deck_size)
            elif i == 'i':
                deck = deal_with_increment(deck, v)
                n_f_pos = follow_card_inc(f_pos, deck_size, v)
            elif i == 'c':
                deck = cut(deck, v)
                n_f_pos = follow_card_cut(f_pos, deck_size, v)
            else:
                raise ValueError('Unknown instruction: ' + i)
                
            n_s_pos = -1
            for j, d in enumerate(deck):
                if d == 2019:
                    n_s_pos = j
                    break
                    
            if n_s_pos != n_f_pos:
                print('Diff. card position after: ', i, v, 'pos', n_s_pos, n_f_pos, s_pos, f_pos)
                #print(deck)
                sys.exit(-1)
            s_pos = n_s_pos
            f_pos = n_f_pos
    return deck

def follow_card(pos, deck_size, instructions, iterations=1):
    for x in range(iterations):
        for (i, v) in instructions:
            if i == 'n':
                pos = folow_card_new(pos, deck_size)
            elif i == 'i':
                pos = follow_card_inc(pos, deck_size, v)
            elif i == 'c':
                pos = follow_card_cut(pos, deck_size, v)
            else:
                raise ValueError('Unknown instruction: ' + i)
    return pos

#for i, t in enumerate([t_0, t_1, t_2, t_3]):
#    ins = shuffleing(t.split('\n'))
#    r = shuffle([x for x in range(10)], ins)
#    print('Test {}: {}'.format(i, r))
    
instructions = []
with open('22.txt', 'r') as f:
    instructions = f.read().split('\n')
    instructions = shuffleing(instructions)

deck = [x for x in range(10007)]
deck = shuffle(deck, instructions)
for i, card in enumerate(deck):
    if card == 2019:
        print('Pos of card 2019', i)
    elif card == 2020:
        print('Pos of card 2020', i)

        
#print('9 ==',  follow_card_cut(2, 10, 3))
#print('0 ==', follow_card_cut(3, 10, 3))
#print('9 ==', follow_card_cut(5, 10, -4))
#print('0 ==', follow_card_cut(6, 10, -4))

#print('2 ==', follow_card_inc(4, 10, 3))
#print('1 ==', follow_card_inc(7, 10, 3))

print('Follow card {} -> {}'.format(2019, follow_card(2019, 10007, instructions)))
print('Follow card {} -> {}'.format(2020, follow_card(2020, 10007, instructions)))

repeat = 1
pos = 2020
orig_pos = pos
deck_size = 119_315_717_514_047
iterations = 101_741_582_076_661
print('Looking for repetition...')
while True:
    pos = follow_card(pos, deck_size, instructions)
    if pos == orig_pos:
        print('Repetition after {} iterations'.format(repeat))
        break
    else:
        repeat += 1

left = iterations % repeat
print('{} shuffle iterations left', left)
final_pos = follow_card(2020, deck_size, instructions, iterations=left)
print('Final pos of card {} is {}'.format(orig_pos, final_pos))
#deck = [x for x in range(119_315_717_514_047)]
#deck = shuffle(deck, instructions, iterations=101741582076661)