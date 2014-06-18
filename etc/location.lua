local json = plugin.json()
local settings = plugin.settings(io)

if not arg[1] or #arg[1] < 3 then
  print('Usage: '..etc.cmdchar..'location <your location>')
  return
end

local filename = 'uvars/'..nick:lower()..'.json'

local locations = settings.load(filename)
locations['location'] = arg[1]

settings.save(filename, locations)

print('Done.')
