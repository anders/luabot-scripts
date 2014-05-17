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


--[[
local timelimit = 1
local t = io.fs.attributes("trap.win")
if t and t.modification + timelimit >= os.time() then
  return false, "no"
end
--]]
if Private.trapped then
  return false, "no"
end
Private.trapped = true


local prev_win_nick = "nobody"
local prev_win_weight = 0
local prev_win_animal = "nothing"
local f = io.open("trap.win")
if f then
  prev_win_nick = f:read() or prev_win_nick
  prev_win_weight = tonumber(f:read()) or prev_win_weight
  prev_win_animal = f:read() or prev_win_animal
  f:close()
end

local d = 4
local newlimit = prev_win_weight + 1
local rrr = (saferandom or math.random)()
if rrr > 0.8 then
  newlimit = newlimit * 2
elseif rrr > 0.5 then
  newlimit = newlimit + 100
else
  newlimit = newlimit + 50
end
if newlimit < 50 then
  newlimit = 50
end

local weight = math.floor((saferandom or math.random)() * newlimit)
assert(weight <= newlimit, "hacker has been banned")
local animal = dbotscript("%animal%")

local result = nick .. " has trapped a " .. weight .. " kg " .. animal
if weight > prev_win_weight then
  result = result .. "! \002Congratulations\002, you beat "
  f = io.open("trap.win", "w")
  f:write(nick, "\n", weight, "\n", animal, "\n")
  f:close()
else
  result = result .. ". Sorry, you did not beat "
end
result = result .. prev_win_nick .. " who trapped a " .. prev_win_weight .. " kg " .. prev_win_animal

return etc.nonickalert(result)
