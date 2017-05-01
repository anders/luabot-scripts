assert(account == 2 or network == "Telegram" and nick == "andersman", 'u aint anders')

arg[1] = arg[1] or ''

local user, key, value = arg[1]:match('([%w%p]+) ([%w%p]+) (.+)')
if Help or not user or not key or not value then
  print('\002Usage:\002 '..etc.cmdchar..'godset nick key value')
  return
end

key = key:lower()
local origkey = key

local function transform(key, value)
  if key:sub(1, 1) == '#' then
    key = key:sub(2)
  end

  local fn = '_set_'..key

  if etc[fn] then
    return etc[fn](value, {user=user, god=true})
  end
  
  return value
end

local err
local value2
if value ~= '-' then
  value2, err = transform(key, value)
end

if value2 then value = value2 end


if key:sub(1, 1) == '#' then
  key = chan:lower()..'~'..key:sub(2)
end

local fn = 'uvars/'..user:lower()..'.json'

local settings = plugin.settings(io)

local t, e = settings.load(fn)
if not t then
  print('\002Error:\002 Unable to load settings: '..tostring(e))
  return
end

if value == '-' then
  value = nil
end

if type(err) == 'table' then
  for k, v in pairs(err) do
    t[k:lower()] = v
  end
end

t[key] = value
settings.save(fn, t)

if value then
  print('Done, set '..origkey..' to '..value..'.')
else
  print('Done, unset '..origkey..'.')
end
