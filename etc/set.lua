-- create etc._set_<keyname>(val) to do validation/transform:
-- contrived example:
--
-- function etc._set_timezone(val)
--   if not not os.attributes('/shared/zoneinfo/'..val) then
--     return false, 'No such timezone!'
--   end
--   return val:lower()
-- end
--

assert(allCodeTrusted(), 'breached whale')

arg[1] = arg[1] or ''

local key, value = arg[1]:match('([%w%p]+) (.+)')
if Help or not key or not value then
  print('\002Usage:\002 '..etc.cmdchar..'set key value')
  return
end

key = key:lower()
local origkey = key

local function transform(key, value)
  if key:sub(1, 1) == '#' then
    key = key:sub(2)
  end

  local fn = '_set_'..key

  if value ~= '-' and etc[fn] then
    return etc[fn](value, {user = nick})
  end
  
  return value
end

local value, extra, options = transform(key, value)
if not value then
  return false, extra
end

options = options or {}

if key:sub(1, 1) == '#' then
  key = chan:lower()..'~'..key:sub(2)
end

local fn = 'uvars/'..nick:lower()..'.json'

local settings = plugin.settings(io)

local t, e = settings.load(fn)
if not t then
  print('\002Error:\002 Unable to load settings: '..tostring(e))
  return
end

if value == '-' then
  value = nil
end

t[key] = value

if extra then
  for k, v in pairs(extra) do
    t[k:lower()] = v
  end
end

settings.save(fn, t)

if value then
  if not options.outputFormat then
    print('Done, set '..origkey..' to '..value..'.')
  else
    print((options.outputFormat):format(origkey, value))
  end
else
  print('Done, unset '..origkey..'.')
end
