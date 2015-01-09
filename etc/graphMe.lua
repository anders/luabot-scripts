if Editor then return end

if arg[2] then
  assert(account == 1, "no")
  nick = arg[2]
end

require "serializer"
local fn = "me.graph"
local obj = serializer.load(io, fn)

local v = (not arg[1] or arg[1] ~= "no" or arg[1] ~= "false" or arg[1] ~= "-") or nil

obj[nick] = v

serializer.save(io, fn, obj)

if v then
  print("You'll be graphed soon")
  if not etc.get('birthday', nick) then
    print("But you need to 'set birthday <here>")
  end
  return
end
print("You're no longer graphed")
