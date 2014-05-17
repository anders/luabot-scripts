-- Usage: |'plain - pipe into plain to strip control codes.
arg, io.stdin = etc.stdio(arg)
print(etc.stripCodes(io.stdin:read("*a")))
