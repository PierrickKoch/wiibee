#! /usr/bin/env python
import sys
import json

filejson = sys.argv[1]
filetemp = sys.argv[2]

with open(filetemp) as f:
    temp = [{'x': x, 'y': y} for x, y in \
            [map(float, line.split()) for line in f.readlines()]]

with open(filejson, 'w') as f:
    data = json.load(f)
    data.extend(temp)
    json.dump(f, data)
