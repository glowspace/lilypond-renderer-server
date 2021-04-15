#!/usr/bin/python3

import sys
data = sys.stdin.readlines()

line = data[0]
vals = line.split(' ')

# input: %%BoundingBox: 127 -262 468 -19

a=int(vals[1])/5
b=int(vals[2])/5
c=int(vals[3])/5
d=int(vals[4])/5

print(" ".join(str(x) for x in [a, -d-1, (c-a)+1, (d-b)+2]))

# output: 25.4 2.8 68.19999999999999 49.6