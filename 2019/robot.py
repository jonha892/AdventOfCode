from enum import Enum

from PIL import Image

from intcode_11 import Intcode

class Direction(Enum):
    UP = 1
    RIGHT = 2
    DOWN = 3
    LEFT = 4
    
class Colors(Enum):
    BLACK = 0
    WHITE = 1

class Robot:
    def __init__(self, prog):
        self.direction = Direction.UP
        self.color = Colors.BLACK
        self.m = {}
        self.posx = 0
        self.posy = 0
        self.brain = Intcode(prog)
        
    def move(self):
        old = (self.posx, self.posy)
        if self.direction == Direction.UP:
            self.posy += 1
        elif self.direction == Direction.RIGHT:
            self.posx += 1
        elif self.direction == Direction.DOWN:
            self.posy -= 1
        elif self.direction == Direction.LEFT:
            self.posx -= 1
        else:
            raise ValueError('Unkown direction state')
        print('old: {} new ({},{})'.format(old, self.posx, self.posy))
    def change_dir(self, d):
        # left 90
        old = self.direction
        if d == 0:
            if self.direction == Direction.UP:
                self.direction = Direction.LEFT
            elif self.direction == Direction.RIGHT:
                self.direction = Direction.UP
            elif self.direction == Direction.DOWN:
                self.direction = Direction.RIGHT
            elif self.direction == Direction.LEFT:
                self.direction = Direction.DOWN
            else:
                raise ValueError('Unkown direction state')
        # right 90
        elif d == 1:
            if self.direction == Direction.UP:
                self.direction = Direction.RIGHT
            elif self.direction == Direction.RIGHT:
                self.direction = Direction.DOWN
            elif self.direction == Direction.DOWN:
                self.direction = Direction.LEFT
            elif self.direction == Direction.LEFT:
                self.direction = Direction.UP
            else:
                raise ValueError('Unkown direction state')
        else:
            raise ValueError('Unknown direction')
        print('Old dir {} -- d: {} -- New dir {}'.format(old, d, self.direction))
    
    def _paint(self):
        keys = self.m.keys()
        minx = min(keys, key=lambda x: x[0])[0]
        maxx = max(keys, key=lambda x: x[0])[0]
        miny = min(keys, key=lambda x: x[1])[1]
        maxy = max(keys, key=lambda x: x[1])[1]
        
        sx = maxx + abs(minx) + 2
        sy = maxy + abs(miny) + 2
        
        offsetx = -minx
        offsety = -miny
        
        k = self.m.keys()
        print(self.m)
        img = Image.new('L', (sx, sy))
        for x in range(minx-1, maxx+1):
            for y in range(miny-1, maxy+1):
                print((x+offsetx, y+offsety))
                if (x, y) in k:
                    img.putpixel((x+offsetx, y+offsety), self.m[(x, y)]*255)
                else:
                    img.putpixel((x+offsetx, y+offsety), 0)
                    
        img.show()
        
    def run(self, start=0):
        brain_input = start
        r = 0
        i = 0
        
        while not self.brain.finished:
            output = self.brain.run(brain_input)
            if len(output) != 2 and not self.brain.finished:
                print('ERROR')
                break
            elif self.brain.finished:
                print('FINISHED')
                break
            c = output[0]
            d = output[1]
            
            if not self.brain.finished:
                self.m[(self.posx, self.posy)] = c
            r = len(self.m.keys())
            
            self.change_dir(d)
            self.move()
            c = self.m.get((self.posx, self.posy), Colors.BLACK.value)
            if c == Colors.WHITE.value:
                brain_input = 1
            elif c == Colors.BLACK.value:
                brain_input = 0
            else:
                raise ValueError('unknown color', c)
            
            #print('Pos ({}, {}) brain_input: {}'.format(self.posx, self.posy, brain_input))
            #print(self.m)
            i += 1
            if i > 100:
                continue
                break
        print('visited: ', r)