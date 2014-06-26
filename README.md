# luabot-scripts

Downloads all scripts from luabot that have changed since the last time the
sync script was run.

## Dependencies
  * Python 2.7
  * git
  * Case-sensitive file system. The sync script will refuse to run if a
    case-insensitive FS is detected.
