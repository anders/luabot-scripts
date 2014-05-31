local t = {}
t.title = "Memory usage of " .. bot
t.vlabel = "Bytes"
t.lowerLimit = 0
t.base = 1024
t.data = { memusage = _memusage() * 1024 }
return t
