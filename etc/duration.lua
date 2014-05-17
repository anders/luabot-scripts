-- usage: <secs>, [<precision>]
-- precision defaults to 2, set to 0 for all precision.

local t = tonumber(arg[1])
assert(t, "Duration expected (number of seconds)")

local places = tonumber(arg[2]) or 2

local map = {
  ye = 365.242 * 86400,
  mo = 30.4368 * 86400,
  da = 86400,
  ho = 3600,
  mi = 60,
  se = 1,
  ms = 0.001,
}

if t < 0 then
  t = -t
end

if etc.isnan(t) then
  return "never"
elseif t == 0 then
  return "0 secs"
elseif t < 0.00000000000000000001 then
  return "a jiffy"
elseif t > 631139000000000000000 then
  return "an eternity"
elseif t < map.ms then
  -- return '' .. (t / map.ms) .. ' ms'
  local nano = 0.000000001
  local pico = 0.000000000001
  if t < nano then
    return '' .. (t / pico) .. ' picoseconds'
  else
    return '' .. (t / nano) .. ' nanoseconds'
  end
end

-- Remove precision when year or month due to inaccuracies.
if t >= map.ye then
  map.da = nil
  map.ho = nil
  map.mi = nil
  map.se = nil
  map.ms = nil
elseif t >= map.mo then
  map.se = nil
  map.ms = nil
end

local order = { 'year', 'month', 'day', 'hour', 'min', 'sec', 'ms' }

local out = {}

for i, unit in ipairs(order) do
  local s = map[unit:sub(1, 2)]
  if not s then
    break
  end
  local x = math.floor(t / s)
  if x > 0 then
    local units = unit
    if x ~= 1 and unit:sub(-1, -1) ~= 's' then
      units = unit .. "s"
    end
    table.insert(out, '' .. x .. ' ' .. units)
    t = t % s
    if #out == places then
      break
    end
  end
end

return table.concat(out, ' ')
