if Editor then return end

Munin = { line = nil, write = print }
Event = { name = "munin-connect" }
print(">", "connect")
etc.on_munin()

Event.name = "munin"
Munin.line = "list"
print(">", Munin.line)
etc.on_munin()

local which = arg[1] or "botstocks"

Event.name = "munin"
Munin.line = "config " .. which
print(">", Munin.line)
etc.on_munin()

Event.name = "munin"
Munin.line = "fetch " .. which
print(">", Munin.line)
etc.on_munin()
