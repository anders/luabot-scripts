#!/usr/bin/env python2.7
import os
import urllib
import json
import re
import subprocess

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

  for mod in j:
    assert re.match(r'^[a-z]*$', mod)
    
    if not os.path.isdir(mod):
      os.mkdir(mod)
    
    for fun in j[mod]:
      assert re.match(r'^[a-zA-Z0-9_]+$', fun)
      
      path = os.path.join(root, mod, fun + '.lua')
      
      if not os.path.exists(path) or lastrun < j[mod][fun]['mtime']:
        # print 'getting script %s.%s' % (mod, fun)
        req = urllib.urlopen(j[mod][fun]['url'])
        resp = req.read()
        with open(path, 'w') as f:
          f.write(resp)
        os.utime(path, (-1, j[mod][fun]['mtime']))
        
        subprocess.check_call(['git', 'add', path], stdout=fnull)

  #print 'committing'
  subprocess.call(['git', 'commit', '--author', 'L. Bot <luabot@codebust.com>', '-m', 'Sync.'], stdout=fnull, stderr=fnull)
  subprocess.call(['git', 'push', '-u', 'origin', 'master'], stdout=fnull, stderr=fnull)

  fnull.close()


if __name__ == '__main__':
  main()
