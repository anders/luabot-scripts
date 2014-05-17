local user = (arg[1] or nick):match('[^/]+')
local plsdecode = arg[2]

local fn = 'uvars/'..user:lower()..'.json'

local settings = plugin.settings(io)

local t, e = settings.load(fn)
if not t then
  return false, e
end

if plsdecode then
  return t
end

local keys = {}
for k in pairs(t) do
  -- skip channel vars for now
  if not k:find('^#') then
    keys[#keys + 1] = k
  end
end
print(user..'\'s keys: '..table.concat(keys, ', '))
