#!/usr/bin/env python2.7
import os
import urllib
import json
import re
import subprocess
from glob import glob

def main():
  req = urllib.urlopen('http://portal.cloud1.codebust.com/u/anders/scripts.lua?json')
  resp = req.read()
  req.close()

  j = json.loads(resp)

  root = os.path.dirname(os.path.realpath(__file__))

  lastrun = 0

  fnull = open(os.devnull, 'w')

  try:
    p = subprocess.Popen(['git', 'log', '-1', 'master', '--format=%ct', '--grep', 'Sync.'], stdout=subprocess.PIPE)
    lastrun = int(p.communicate()[0])
  except:
    pass

  # Add new or modified scripts.
  for mod in j:
    assert re.match(r'^[a-z]*$', mod)
    
    if not os.path.isdir(mod):
      os.mkdir(mod)
    
    for fun in j[mod]:
      assert re.match(r'^[a-zA-Z0-9_]+$', fun)
      
      path = os.path.join(root, mod, fun + '.lua')
      
      if not os.path.exists(path) or lastrun < j[mod][fun]['mtime']:
        req = urllib.urlopen(j[mod][fun]['url'])
        resp = req.read()
        with open(path, 'w') as f:
          f.write(resp)
        
        subprocess.check_call(['git', 'add', path], stdout=fnull)

  # Find out if a script was deleted or not.
  # Done by finding Lua scripts that weren't in the list fetched earlier.
  # If a deleted script is found, git rm it.
  for mod in j:
    for path in glob(os.path.join(root, mod) + '/*.lua'):
      name = os.path.splitext(os.path.basename(path))[0]
      if not name in j[mod]:
        subprocess.check_call(['git', 'rm', path], stdout=fnull)

  subprocess.call(['git', 'commit', '--author', 'L. Bot <luabot@codebust.com>', '-m', 'Sync.'], stdout=fnull, stderr=fnull)
  subprocess.call(['git', 'push', '-u', 'origin', 'master'], stdout=fnull, stderr=fnull)

  fnull.close()


if __name__ == '__main__':
  main()
