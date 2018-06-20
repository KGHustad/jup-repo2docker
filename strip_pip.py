#!/usr/bin/env python

# remove pip packages from environment.yml file
import sys

ignore = False
for line in sys.stdin:
    if "pip:" in line:
        # pip packages come last, so we can ignore the rest of the file
        ignore = True

    if not ignore:
        sys.stdout.write(line)


