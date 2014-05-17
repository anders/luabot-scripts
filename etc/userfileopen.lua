-- Usage: etc.userfileopen(name) returns an open file object, or nil,err on error, given the user-specified file name. If name starts with etc.cmdchar then it's considered to be user code.
local fn, fnerr = etc.userfile(arg[1])
if not fn then
  return fn, fnerr
end
local io
if fn:find("/pub/scripts/", 1, true) == 1
    or fn:find("/shared/", 1, true) == 1
    then
  io = assert(guestloadstring("return io"))()
else
  io = assert(godloadstring("return io"))()
end
if arg[3] == '-fast' then
  io._fast = true
end
return io.open(fn, arg[2] or 'r')
