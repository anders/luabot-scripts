local allowed = {
  ['byte[]'] = true,
  anders = true
}

if not allowed[nick:lower()] then
  print('sry, you aint on the list of allowed users')
  return
end

local storage = require 'storage'

local key, value = arg[1]:match('(%S+) (.+)')
if not key or not value or Help then
  print('Usage: \'doc key help text')
  return
end

local obj = storage.load(io, 'dbot.docs')
assert(key, 'dumbass key')
assert(value, 'dumbass value')
obj[key] = value
storage.save(obj)
