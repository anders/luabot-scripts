local settings = plugin.settings(io)
local key = assert(arg[1], 'expected key')
if key:sub(1, 1) == '#' then
  key = chan:lower()..'~'..key:sub(2)
end
local user = (arg[2] or nick):match('[^%s]+')
local path = 'uvars/'..user:lower()..'.json'
local value = settings.load(path)[key:lower()]
if key == 'password' then
  return ('*'):rep(#value)
else
  return value
end
