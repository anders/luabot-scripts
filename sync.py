#!/usr/bin/env python2.7
import os
import urllib
import json
import re
import subprocess
from glob import glob


SCRIPTS_URL = 'http://portal.cloud1.codebust.com/u/anders/scripts.lua?json'

# git settings
GIT = 'git'
AUTHOR_NAME = 'L. Bot <luabot@codebust.com>'
BRANCH_NAME = 'master'
REMOTE_NAME = 'origin'


def main():
    script_path = os.path.realpath(__file__)
    if os.path.exists(script_path.upper()):
        raise Exception("Case insensitive filesystems are not supported.")

    root = os.path.dirname(script_path)

    req = urllib.urlopen(SCRIPTS_URL)
    resp = req.read()
    req.close()

    j = json.loads(resp)

    # UNIX timestamp of the last sync commit.
    lastrun = 0

    try:
        p = subprocess.Popen([GIT, 'log', '-1', 'master', '--format=%ct',
                              '--grep', 'Sync.'], stdout=subprocess.PIPE)
        lastrun = int(p.communicate()[0])
    except:
        pass

    fnull = open(os.devnull, 'w')

    # Lists of changed scripts.
    added = []
    deleted = []
    changed = []

    # Add new or modified scripts.
    for mod in j:
        assert re.match(r'^[a-z]*$', mod)

        if not os.path.isdir(mod):
            os.mkdir(mod)

        for fun in j[mod]:
            assert re.match(r'^[a-zA-Z0-9_]+$', fun)

            path = os.path.join(root, mod, fun + '.lua')
            new = not os.path.exists(path)

            if not os.path.exists(path) or lastrun < j[mod][fun]['mtime']:
                req = urllib.urlopen(j[mod][fun]['url'])
                resp = req.read()
                with open(path, 'w') as f:
                    f.write(resp)

                name = '%s.%s' % (mod, fun)
                if new:
                    added.append(name)
                else:
                    changed.append(name)
                subprocess.check_call([GIT, 'add', path], stdout=fnull)

    # Find out if a script was deleted or not.
    # Done by finding Lua scripts that weren't in the list fetched earlier.
    # If a deleted script is found, git rm it.
    for mod in j:
        for path in glob(os.path.join(root, mod) + '/*.lua'):
            name = os.path.splitext(os.path.basename(path))[0]
            if name not in j[mod]:
                deleted.append('%s.%s' % (mod, name))
                subprocess.check_call([GIT, 'rm', path], stdout=fnull)

    # Build a commit message listing all changed scripts.
    commit_message = ['Sync.']

    for diff, name in ((added,   'Added'),
                       (changed, 'Changed'),
                       (deleted, 'Deleted')):
        if diff:
            diff.sort()
            commit_message.append('\n%s:' % name)
            for name in diff:
                commit_message.append('  %s' % name)

    commit_message = '\n'.join(commit_message)

    subprocess.call([GIT, 'commit', '--author', AUTHOR_NAME, '-m',
                     commit_message], stdout=fnull, stderr=fnull)
    subprocess.call([GIT, 'push', '-u', REMOTE_NAME, BRANCH_NAME],
                    stdout=fnull, stderr=fnull)

    fnull.close()


if __name__ == '__main__':
    main()
