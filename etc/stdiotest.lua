-- print("untouched input:", arg[1])
arg, io.stdin = etc.stdio(arg)
print("arg:", etc.t(arg or {}))
print("stdin:", io.stdin:read("*a"))
