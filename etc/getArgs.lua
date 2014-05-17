-- Usage: local flags, arg1, arg2 = etc.getArgs(etc.splitArgs(arg[1]))

-- Author: sdonovan
-- License: MIT/X11
-- Modified by dbot :D

--- Extract flags from an arguments list.
-- Given string arguments, extract flag arguments into a flags set.
-- For example, given "foo", "--tux=beep", "--bla", "bar", "--baz", "-la"
-- it would return the following:
-- {bla = true, tux = "beep", baz = true, l = true, a = true}, "foo", "bar".

local args = arg
if #arg == 1 and type(arg[1]) == "table" then
  args = arg[1]
end
local flags = {}
for i = #args, 1, -1 do
  assert(type(args[i]) == "string", "Expected string at index " .. i .. " but got " .. type(args[i]))
  local flag = args[i]:match("^%-%-(.*)")
  if flag then
    local var,val = flag:match("([a-z_%-]*)=(.*)")
    if val then
      flags[var] = val
    else
      flags[flag] = true
    end
    table.remove(args, i)
  elseif args[i]:sub(1, 1) == '-' then
    for j = 2, #args[i] do
      flags[args[i]:sub(j, j)] = true
    end
    table.remove(args, i)
  end
end
return flags, unpack(args)
