from collections import defaultdict

def multiple(base, step, target):
    #print(base, step, target)
    if base >= target:
        return 1, base - target
    i = 1
    while base+i*step < target:
        i += 1
    return i, (base + i*step) - target

class Converter:
    def __init__(self, formulas):
        self.formulas = {}
        self.parse_text_formulas(formulas)        
        
    def parse_text_formulas(self, formulas):
        for f in formulas.split('\n'):
            i = []
            t = f.split('=>')
            #p1 = [x.split(' ') for x in t[0].split(',')]
            p1 = []
            for x in t[0].split(','):
                x = x.split(' ')
                x = list(filter(lambda y: y != '', x))
                p1.append(x)
            for p in p1:
                #print(p)
                assert len(p) == 2
                
                i.append((int(p[0]), p[1]))
            p2 = t[1].split(' ')
            p2 = list(filter(lambda x: x != '', p2))
            #print(p2)
            assert len(p2) == 2
            o = (int(p2[0]), p2[1])
            #print(p1, i, o)
            if o[1] in self.formulas.keys():
                raise ValueEroor('duplicate key')
            self.formulas[o[1]] = (o[0], i)
        
    def price_of_fuel(self, rest=None):
        remaining = {x[1]:x[0] for x in self.formulas['FUEL'][1]}
        if rest == None:
            rest = defaultdict(int)
        ores = 0
        #print(remaining)
        while True:
            tmp = []
            #print('Remaining elements: ', remaining)
            e = list(remaining.keys())[0]
            q = remaining.pop(e)
            formula = self.formulas[e]
            #print('Elment: {}, quantity; {} with formula: {}'.format(e, q, formula))
            
            if rest[e] >= q:
                rest[e] -= q
                q = 0
            else:
                #q -=           
                factor, r = multiple(rest[e], formula[0], q)
                #print('Factor: {}, r: {}'.format(factor, r))
                tmp = [(c[1], factor*c[0]) for c in formula[1]]
                rest[e] = r
            
            ##print('Rest: {}'.format(rest))
            #print('Temp list: {}'.format(tmp))
            for t in tmp:
                if t[0] == 'ORE':
                    ores += t[1]
                    continue
                if t[0] in remaining.keys():
                    remaining[t[0]] += t[1]
                else:
                    remaining[t[0]] = t[1]
            if len(remaining.keys()) == 0:
                break
            #print('ORES', ores)
            #print('....')
        #print(ores)
        return ores, rest
    
    def fuel_per_ore(self, ores):
        total = 0
        ores_spent = 0
        rest = defaultdict(int)
        
        while True:
            o, rest = self.price_of_fuel(rest)
            ores_spent += o
            if ores_spent <= ores:
                total += 1
                print(total)
            else:
                break
        return total, ores_spent