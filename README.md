# luabot-scripts

Downloads all scripts from luabot that have changed since the last time the
script was run.

## Dependencies
  * Python 2.7
  * git

## Bugs
  * It does not deal with case-insensitive file systems. Script names may
    conflict and wreak havoc on the history.
  * It does not check if a script was deleted.
