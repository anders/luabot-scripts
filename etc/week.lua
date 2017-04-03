local who = arg[1] or nick
local week, ok, zone_short = etc.timezone(who, '%W', nil, true)
if ok then
  return "W"..week.." ("..zone_short..")"
else
  return "W"..os.date("!%W").." (UTC)"
end
