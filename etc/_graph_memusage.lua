local t = {}
t.title = "Memory usage of " .. bot
local a, b = _memusage()
t.vlabel = b or "KBytes"
t.lowerLimit = 0
t.data = { memusage = a }
return t
