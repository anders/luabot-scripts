-- set(key, value, [account/uid])
-- key can be prefixed with # for local

local storage = require 'storage'

local key, value, uid = ...
if key and not value then
  key, value = key:match('([%w%p]+) (.+)')
end

if type(uid) == 'string' then
  uid = getuid(uid)
end

if not uid then
  uid = account
end

if not key then
  return false, 'need a key'
end

if not value then
  return false, 'need a value'
end

if not uid then
  return false, 'need an account'
end

key = key:lower()
local origkey = key

local function transform(key, value)
  if key:sub(1, 1) == '#' then
    key = key:sub(2)
  end

  local fn = '_set_'..key
  if etc[fn] then
    return etc[fn](value)
  end

  return value
end

if key:sub(1, 1) == '#' then
  key = chan:lower()..'~'..key:sub(2)
end

local userdata = storage.load(io, 'userdata-'..uid..'.dat')

if value == '-' then
  value = nil
end

local value, extra = transform(key, value)
if not value then
  return false, extra
end

userdata[key] = value
if extra then
  for k, v in ipairs(extra) do
    userdata[k:lower()] = v
  end
end

assert(storage.save(userdata))
if value then
  print('Done, set '..origkey..' to '..value..'.')
else
  print('Done, unset '..origkey..'.')
end
