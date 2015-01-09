if Editor then return end
local t = {}
t.title = "Birthday Countdown - use 'GraphMe and 'set birthday"
t.vlabel = "Days until Birthday"
t.lowerLimit = 0
t.scale = false
t.data = { }

local now = os.time()
require "serializer"
local fn = "me.graph"
local obj = serializer.load(io, fn)
for nick, v in pairs(obj) do
  local time = etc.bdaytime(nick)
  if time and time > now then
    t.data[nick] = math.floor((time - now) / 60 / 60 / 24)
  end
end
-- serializer.save(io, fn, obj)

return t
