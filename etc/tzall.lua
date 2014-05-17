return etc.all("'tz")
--[[ -- olde:
local t = {}

local fmt = etc.get('timeformat', nick) or "%H:%M (%I:%M %p)"

for i, n in ipairs(nicklist()) do
  -- print("calling etc.timezone('" .. n .. "', '" .. fmt .. "')")
  local time, offset = etc.timezone(n, fmt)
  if time then
    t[#t + 1] = { nick = n, time = time, offset = offset }
  end
end

table.sort(t, function(a, b)
  -- return a.time < b.time
  return a.offset < b.offset
end)

local result = ""
for i, t in ipairs(t) do
  if result ~= "" then
    result = result .. ", "
  end
  result = result .. t.nick .. " at " .. t.time
end
return result
--]]