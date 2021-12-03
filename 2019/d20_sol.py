from collections import defaultdict, deque
import sys

G = []
for line in open(sys.argv[1]).readlines():
    assert line[-1] == '\n'
    line = line[:-1]
    G.append(list(line))
DR = [-1,0,1,0]
DC = [0,1,0,-1]
count = 0
P = defaultdict(dict)
PINV = {}
E = defaultdict(set)
for r in range(len(G)):
    for c in range(len(G[r])):
        if 'A'<=G[r][c]<='Z':
            for d1 in range(4):
                r2,c2 = r+DR[d1],c+DC[d1]
                r3,c3 = r2+DR[d1],c2+DC[d1]
                if 0<=r3<len(G) and 0<=c3<len(G[r]) and 'A'<=G[r2][c2]<='Z' and G[r3][c3]=='.':
                    if d1 in [0,3]:
                        id_ = (G[r][c], G[r2][c2])
                    else:
                        id_ = (G[r2][c2], G[r][c])
                    if id_ == ('A', 'A'):
                        start = (r3,c3,0)
                    elif id_ == ('Z', 'Z'):
                        end = (r3,c3,0)
                    else:
                        is_up = (r<=3 or c<=3 or r+3>=len(G) or c+3>=len(G[r]))
                        P[id_][is_up] = (r3,c3)
                        PINV[(r3,c3)] = (id_,is_up)
        if G[r][c]=='.':
            for d in range(4):
                rr,cc = r+DR[d],c+DC[d]
                if 0<=rr<len(G) and 0<=cc<len(G[r]) and G[rr][cc]=='.':
                    E[(r,c)].add((rr,cc))
                    E[(rr,cc)].add((r,c))

#for k,v in P.items():
#    if len(v) != 2:
#        print '{} {}'.format(k,v)
#    for i in range(len(v)):
#        for j in range(i+1,len(v)):
#            E[v[i]].add(v[j])
#            E[v[j]].add(v[i])

def getE(pos):
    (r,c,level) = pos
    ans = []
    for y in E[(r,c)]:
        ans.append((y[0], y[1], level))
    if (r,c) in PINV:
        id_,is_up = PINV[(r,c)]
        dest = P[id_][not is_up]
        if is_up and level>0:
            ans.append((dest[0], dest[1], level-1))
        elif (not is_up):
            ans.append((dest[0], dest[1], level+1))
    return ans

Q = deque([(start, 0)])
SEEN = set()
while Q:
    x,d = Q.popleft()
    assert x[2]>=0
    if x in SEEN:
        continue
    SEEN.add(x)
    #print(x,d)
    if x == end:
        print(x,d)
        sys.exit(0)
    for y in getE(x):
        Q.append((y, d+1))