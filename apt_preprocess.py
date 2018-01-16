#!/usr/bin/env python
from __future__ import print_function
import sys

for line in sys.stdin:
    line = line.strip()

    # ignore empy lines
    if line == "":
        continue

    # ignore comment lines
    if line.startswith('#'):
        continue

    print(line)
