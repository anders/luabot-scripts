#!/usr/bin/env python2.7
import os
import urllib
import json
import re
import subprocess
from glob import glob


SCRIPTS_URL = "http://portal.cloud1.codebust.com/u/anders/scripts.lua?json"

# git settings
GIT = "git"
AUTHOR_NAME = "L. Bot"
AUTHOR_EMAIL = "luabot@codebust.com"
BRANCH_NAME = "master"
REMOTE_NAME = "origin"


EMAIL_MAP = {
    "anders": "anders1@gmail.com",
}


def extend_list(a, b):
    a.extend(b)
    return a


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

    os.environ["GIT_COMMITTER_NAME"] = AUTHOR_NAME
    os.environ["GIT_COMMITTER_EMAIL"] = AUTHOR_EMAIL

    try:
        p = subprocess.Popen([GIT, "log", "-1", "master", "--format=%ct",
                              "--grep", "Sync."], stdout=subprocess.PIPE)
        lastrun = int(p.communicate()[0])
    except:
        pass

    fnull = open(os.devnull, "w")

    scripts_by_user = {}
    path_uid = {}

    # Add new or modified scripts.
    for mod in j:
        assert re.match(r"^[a-z]*$", mod)

        if not os.path.isdir(mod):
            os.mkdir(mod)

        for fun in j[mod]:
            assert re.match(r"^[a-zA-Z0-9_]+$", fun)

            path = os.path.join(root, mod, fun + ".lua")
            new = not os.path.exists(path)

            if not os.path.exists(path) or lastrun < j[mod][fun]["mtime"]:
                req = urllib.urlopen(j[mod][fun]["url"])
                resp = req.read()
                with open(path, "w") as f:
                    f.write(resp)

                user = scripts_by_user.setdefault(j[mod][fun]["owner"], [])
                user.append(path)

                path_uid[path] = j[mod][fun]["uid"]

    for user in scripts_by_user:
        for path in scripts_by_user[user]:
            subprocess.check_call(["echo", GIT, "add", path], stdout=fnull)
        os.environ["GIT_AUTHOR_NAME"] = user
        os.environ["GIT_AUTHOR_EMAIL"] = EMAIL_MAP.get(user, "user%d@codebust.com" % path_uid[path])
        subprocess.check_call(extend_list([GIT, "commit", "-m", "Sync."], scripts_by_user[user]), stdout=fnull)

    # Find out if a script was deleted or not.
    # Done by finding Lua scripts that weren't in the list fetched earlier.
    # If a deleted script is found, git rm it.
    deleted_scripts = []
    for mod in j:
        for path in glob(os.path.join(root, mod) + "/*.lua"):
            name = os.path.splitext(os.path.basename(path))[0]
            if name not in j[mod]:
                deleted_scripts.append(path)

    os.environ["GIT_AUTHOR_NAME"] = AUTHOR_NAME
    os.environ["GIT_AUTHOR_EMAIL"] = AUTHOR_EMAIL

    if len(deleted_scripts) > 0:
        subprocess.check_call(extend_list([GIT, "rm"], deleted_scripts), stdout=fnull)
        subprocess.check_call(extend_list([GIT, "commit", "-m", "Delete old scripts."], deleted_scripts), stdout=fnull)

    subprocess.call([GIT, "push", "-u", REMOTE_NAME, BRANCH_NAME],
                    stdout=fnull, stderr=fnull)

    fnull.close()


if __name__ == "__main__":
    main()
