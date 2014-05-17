-- Usage: 'lgrep string - similar to grep but using lua patterns.

arg, io.stdin = etc.stdio(arg)
local flags, needle = etc.getArgs(arg)
return etc.grepcore(io.stdin, needle, flags)
