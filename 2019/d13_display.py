from enum import Enum
from collections import Counter

from PIL import Image

class TileType(Enum):
    EMPTY = 0
    WALL = 1
    BLOCK = 2
    HPADDLE = 3
    BALL = 4

class Display:
    def __init__(self, sequence):
        self.m = {}
        self.score = 0
        self._interpret_sequence(sequence)
    
    
    def _interpret_sequence(self, s):
        assert (len(s) % 3) == 0
        for x, y, c in zip(s[0::3], s[1::3], s[2::3]):
            #print(x, y, c)
            if x == -1 and y == 0:
                self.score = c
            elif c == TileType.EMPTY.value:
                self.m[(x, y)] = TileType.EMPTY
            elif c == TileType.WALL.value:
                self.m[(x, y)] = TileType.WALL
            elif c == TileType.BLOCK.value:
                self.m[(x, y)] = TileType.BLOCK
            elif c == TileType.HPADDLE.value:
                self.m[(x, y)] = TileType.HPADDLE
            elif c == TileType.BALL.value:
                self.m[(x, y)] = TileType.BALL
            else:
                raise ValueError('Unknown tile type: {}'.format(c))
                
    def display(self):
        #print(self.m)
        minx = min(self.m.keys(), key=lambda x: x[0])[0]
        miny = min(self.m.keys(), key=lambda x: x[1])[1]
        
        maxx = max(self.m.keys(), key=lambda x: x[0])[0]
        maxy = max(self.m.keys(), key=lambda x: x[1])[1]
        
        xs = maxx-minx
        ys = maxy-miny
        print(minx, maxx, miny, maxy, xs, ys)
        
        img = Image.new('RGB', (50, 50))
        for (x, y), v in self.m.items():
            yt = y#ys - y
            #print(x, yt)
            if v == TileType.EMPTY:
                img.putpixel((x, yt), (0,0,0))
            elif v == TileType.WALL:
                img.putpixel((x, yt), (255,0,0))
            elif v == TileType.BLOCK:
                img.putpixel((x, yt), (0,0,255))
            elif v == TileType.HPADDLE:
                img.putpixel((x, yt), (255,255,0))
            elif v == TileType.BALL:
                img.putpixel((x, yt), (0,255,0))
            else:
                raise ValueError('unknown tile')
        img.show()
    
    def display_console(self):
        maxy = max(self.m.keys(), key=lambda x: x[1])[1]
        
        for y in range(maxy+2):
            row = ''
            for x in range(50):
                v = self.m.get((x, y), None)
                if v == TileType.EMPTY:
                    row += ' '
                elif v == TileType.WALL:
                    row += '-'
                elif v == TileType.BLOCK:
                    row += 'X'
                elif v == TileType.HPADDLE:
                    row += '_'
                elif v == TileType.BALL:
                    row += 'o'
                elif v == None:
                    row += ' '
            print(row)
        print('SCORE:\t', self.score)
    def p1(self):
        t = Counter()
        for k, v in self.m.items():
            t[v] += 1
            if v == TileType.BLOCK:
                print(k)
        print(t)
        
    def get_ball_pos(self):
        r = []
        for k, v in self.m.items():
            if v == TileType.BALL:
                r.append(k)
        assert len(r) <= 1
        if len(r) == 0:
            return (-1, -1)
        return r[0]
    
    def get_paddle_pos(self):
        r = []
        for k, v in self.m.items():
            if v == TileType.HPADDLE:
                r.append(k[0])
        assert len(r) <= 1
        if len(r) == 0:
            return -1
        return r[0]