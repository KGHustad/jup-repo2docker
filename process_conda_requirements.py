#!/usr/bin/env python

#import argparse
#
#parser = argparse.ArgumentParser()
#parser.add_argument('--outdir', default='.', type=str)

import sys
import re

packages = set()
extra_channels = set()
for line in sys.stdin:
    line = line.strip()
    if line == "":
        continue
    elif line.startswith('#'):
        # comment line
        continue

    print(line)
    words = line.split()
    package = words[0]
    packages.add(package)

    if len(words) == 1:
        continue

    m = re.match("<(.+)>", words[1])
    if m is not None:
        extra_channel = m.group(1)
        extra_channels.add(extra_channel)
    else:
        sys.stderr.write("error in conda requirements: expected <channel> after package\n")
        sys.exit(1)

conda_package_list_filename = 'binder/conda_packages.txt'
extra_channel_list_filename = 'binder/conda_extra_channels.txt'

print(sorted(packages))
print(sorted(extra_channels))

with open(conda_package_list_filename, 'w') as f:
    for package in sorted(packages):
        f.write("%s\n" % package)

with open(extra_channel_list_filename, 'w') as f:
    for extra_channel in sorted(extra_channels):
        f.write("%s\n" % extra_channel)
