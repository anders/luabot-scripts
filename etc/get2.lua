-- get(var)
-- get(var, name/UID)
-- var can be prefixed with # for local

local storage = require 'storage'

local var, acc = ...

if not var then
  return false, 'need var'
end

if not acc then
  acc = account
else
  if type(acc) == 'string' then
    acc = getuid(acc)
  end
end

if not acc then
  return false, 'no such account/not identified'
end

if var:sub(1, 1) == '#' then
  var = chan:lower()..'~'..var:sub(2)
end


local userdata = storage.load(io, 'userdata-'..acc..'.dat')
return userdata[var:lower()]
