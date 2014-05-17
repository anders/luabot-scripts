local settings = plugin.settings(io)
local fn = 'uvars.'..nick:lower()

local t = settings.load(fn)
return t[arg[1]]
