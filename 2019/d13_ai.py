import time

class AI:
    def __init__(self):
        self.bx = -1
        self.by = -1
        self.px = -1
        self.ball_d = 0
        self.init = True
    
    def new_state(self, bx, by, px):
        #right
        if bx > self.bx:
            self.ball_d = 1
        #left
        elif bx < self.bx:
            self.ball_d = -1
        # neutral
        elif bx == self.bx:
            self.ball_d = 0
        print('AI', self.bx, bx, self.ball_d)
        self.bx = bx
        self.by = by
        self.px = px
        if self.ball_d != 0:
            return
            time.sleep(0.1)
        
    def next_move(self):
        if self.bx > self.px:
            return 1
        if self.bx < self.px:
            return -1
        if self.bx == self.px:
            return 0
        #return self.d