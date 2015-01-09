if Editor then return end

require "serializer"
local fn = "me.graph"
local obj = serializer.load(io, fn)

local v = (not arg[1] or arg[1] ~= "no" or arg[1] ~= "false" or arg[1] ~= "-") or nil

obj[nick] = v

serializer.save(io, fn, obj)

return v and "You'll be graphed soon" or "You're no longer graphed"
