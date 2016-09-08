#! /usr/bin/env python
import sys

name = sys.argv[1]
data = [{'x': x, 'y': y} for x, y in \
        [map(float, line.split()) for line in sys.stdin.readlines()]]

print("%s = %r"%(name, data))
