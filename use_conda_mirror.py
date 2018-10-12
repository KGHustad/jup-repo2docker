#!/usr/bin/env python3

import json
import os
import re
import requests
import sys

def mirror_available(base_url, channel):
    print(f'Verifying {base_url}/{channel}')
    try:
        return (requests.head(f'{base_url}/{channel}/noarch/repodata.json', timeout=0.5).status_code < 400)
    except:
        return False

mirror_config_filename = 'conda_mirror.json'
if not os.path.isfile(mirror_config_filename):
    print("No conda mirror config found")
    sys.exit(0)

with open(mirror_config_filename, 'r') as f:
    mirror_config = json.load(f)

#print(mirror_config)
if 'base_url' not in mirror_config:
    print("Mirror config is missing base URL")
    sys.exit(1)

if 'channels' not in mirror_config:
    print("Mirror config is missing channel list")
    sys.exit(1)

base_url = mirror_config['base_url']
channels_to_replace = mirror_config['channels']

# conda will use ~/.condarc as config file unless CONDARC is set in env
if 'CONDARC' in os.environ:
    conda_config_filename = os.path.expanduser(os.environ['CONDARC'])
else:
    conda_config_filename = os.path.expanduser('~/.condarc')

with open(conda_config_filename, 'r') as f:
    old_conda_config = f.read()

new_conda_config = old_conda_config
for channel in channels_to_replace:
    if not mirror_available(base_url, channel):
        print(f'Channel unavailable: {base_url}/{channel}')
        continue
    new_channel = f'{base_url}/{channel}'
    new_conda_config = re.sub('^(\\s+-\\s*){channel}$'.format(channel=channel), 
        '\\1{new_channel}'.format(new_channel=new_channel), 
        new_conda_config, 
        flags=re.M)

#print(new_conda_config)
   
with open(conda_config_filename, 'w') as f:
    f.write(new_conda_config)

