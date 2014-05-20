if etc._foobar then etc._foobar(_G) end -- Hacker Games.
if Editor then return end

local r = require 'RandomLua'
local rng = r.mwc()

local function assert(x, e)
  if not x then print('assert failed:', e); while true do end end
end

function sleep() assert(false, 'hacker plans foiled') end

assert(require 'RandomLua' ~= require 'bit', 'hacker attempt caught')
assert((require('bit')).bnot, 'hacker attempt caught')

assert(tonumber('1337')==1337, 'hacker attempt caught')
assert(tonumber('1332')==1332, 'hacker attempt caught')

local n = rng:random(1,9999999)
assert(tonumber(tostring(n))==n, 'hacker attempt caught')
assert(tostring(1234)=='1234', 'hacker attempt caught')
assert(tostring(100)=='100', 'hacker attempt caught')
assert(tonumber(('%d'):format(n))==n, 'hacker attempt caught')

local amount = 1
local timelimit = 1
if account == 2 then
  amount = 2
  timelimit = 0
elseif account == 4 then
  timelimit = 10
end

local t = io.fs.attributes('add.db')
if t and t.modification + timelimit >= os.time() then
  print('Rot in hell for trying to spam the add game, '..nick..'.')
  return
end

local f, d = io.open('add.db', 'r')
if f then
  d = f:read('*a')
  f:close()
end

for i=1, math.random(1, 1000) do
  if math.random(1, 2) == 1 then local _ = tonumber(math.random(1, 1000)) end
end
  d = (tonumber(d) or 0) + amount

f = io.open('add.db', 'w')
f:write(tostring(d))
f:close()

return ('Thanks '..nick..', the number is now '..d..'.')