-- Usage: 'diff left_file right_file

local diff = require "diff"

local flags, lfn, rfn = etc.getArgs(etc.splitArgs(arg[1] or ''))
assert(lfn, "Need left file")
assert(rfn, "Need right file")

local fleft = assert(etc.userfileopen(lfn))
local fright = assert(etc.userfileopen(rfn))

local left = fleft:read("*a")
local right = fright:read("*a")

fleft:close()
fright:close()

if flags.to_html then
  return diff.diff(left, right):to_html()
end

if flags.colorful then
  return etc.html2irc(diff.diff(left, right):to_html())
end

local unified = false
if flags.u then
  unified = 0 -- using default unified=0 though usually 3.
end
if flags.U or flags.unified then
  assert(tonumber(flags.U) or tonumber(flags.unified) == 0, "--unified=0 only")
  unified = 0
end

if unified then
  print("--- " .. lfn)
  print("+++ " .. rfn)
end

for _, token in ipairs(diff.diff(left, right)) do
  local str, dif = token[1], token[2]
  if dif == "in" then
    if unified then
      print("+" .. str)
    else
      print("> " .. str)
    end
  elseif dif == "out" then
    if unified then
      print("-" .. str)
    else
      print("< " .. str)
    end
  end
end
