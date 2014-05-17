-- rawset('anders', 'key', 'val')
local settings = plugin.settings(io)
local user = assert(arg[1], 'expected user')
local key = assert(arg[2], 'expected key')
if key:sub(1, 1) == '#' then
  key = chan:lower()..'~'..key:sub(2)
end
key = key:lower()
local value = arg[3]
local path = 'uvars/'..user:lower()..'.json'
local t = settings.load(path)
t[key] = value
settings.save(path, t)
