from d13_display import Display
from d13_ai import AI
from intcode_11 import Intcode

import time

t0 = [1,2,3,6,5,4]

def p1(prog):
    cmp = Intcode(prog[:])
    #cmp._set_addr(0, 2)
    data = cmp.run(manual_input=True)
    dsp = Display(data)
    dsp.p1()
    dsp.display()

def p2(prog):
    cmp = Intcode(prog[:])
    cmp._set_addr(0, 2)
    
    dsp = Display([])
    ai = AI()
    d = 0
    while not cmp.finished:
        data = cmp.run(_input=d, manual_input=False, output_len=3)
        dsp._interpret_sequence(data)
        dsp.display_console()
        
        bx, by = dsp.get_ball_pos()
        px = dsp.get_paddle_pos()
        ai.new_state(bx, by, px)
        d = ai.next_move()
        time.sleep(0.2)
    
with open('13.txt', 'r') as f:
    prog = [int(x) for x in f.read().split(',')]
    
    #p1(prog)
    p2(prog)