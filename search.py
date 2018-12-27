#!/usr/bin/python

# Hacky JSON transformation to improve the
# searchability of GeoJSON.

# Suffix with state name and/or country to
# resolve ambigous matches.

import sys
import json

def is_in(j):
  if 'features' in j:
    for f in j['features']:
      if 'properties' in f:
        if 'name' in f['properties'] and 'is_in:state_code' in f['properties']:
          f['properties']['unique'] = '%s %s'%(f['properties']['name'], f['properties']['is_in:state_code'])
          del f['properties']['is_in:state_code']
        else:
          f['properties']['unique'] = '%s'%(f['properties']['name'])
  #     print('%s'%(f['properties']))

def suffix(j, state):
  if 'features' in j:
    for f in j['features']:
      if 'properties' in f:
        if 'name' in f['properties']:
          f['properties']['name'] = '%s %s'%(f['properties']['name'], state)

j = json.load(sys.stdin)
suffix(j, "QLD")
print(json.dumps(j))

