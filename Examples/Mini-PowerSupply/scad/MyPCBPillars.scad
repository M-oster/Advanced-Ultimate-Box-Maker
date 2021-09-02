
silver                          = [0.75, 0.75, 0.75];

// b_thread and t_thread are inverted, so that the thread of teh pillar is top and the inner thread is buttom
//                                                  n        t  h      o          i         o  i     o         i       b  t
//                                                  a        h  e      d          d         f  f
//                                                  m        r  i                           n  n     c         c       t  t
//                                                  e        e  g                                    o         o       h  h
//                                                           a  h                                    l         l       r  r
//                                                           d  t                                    o         o       e  e
//                                                                                                   u         u       a  a
//                                                           d                                       r         r       d  d

M3x8_hex_pillar        = ["M3x8_hex_pillar",      "hex",     3, 8  , 5/cos(30), 5/cos(30),  6, 6, "silver",  silver,   6, -6.5];
M3x10_hex_pillar       = ["M3x10_hex_pillar",     "hex",     3, 10 , 5/cos(30), 5/cos(30),  6, 6, "silver",  silver,   8, -8];
M3x15_hex_pillar       = ["M3x15_hex_pillar",     "hex",     3, 15 , 5/cos(30), 5/cos(30),  6, 6, "silver",  silver,   8, -8];
M3x20_hex_pillar       = ["M3x20_hex_pillar",     "hex",     3, 20 , 5/cos(30), 5/cos(30),  6, 6, "silver",  silver,   8, -8];
M3x25_hex_pillar       = ["M3x25_hex_pillar",     "hex",     3, 25 , 5/cos(30), 5/cos(30),  6, 6, "silver",  silver,   8, -6];
M4x10_hex_pillar       = ["M4x10_hex_pillar",     "hex",     4, 10 , 8/cos(30), 8/cos(30),  6, 6, "silver",  silver,   8, -8];

pillars = [M3x8_hex_pillar, M3x10_hex_pillar, M3x15_hex_pillar, M3x20_hex_pillar, M3x25_hex_pillar, M4x10_hex_pillar];
 
 
//use <MyPillar.scad>
use <NopSCADlib/vitamins/pillar.scad>

