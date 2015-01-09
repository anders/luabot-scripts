local who = arg[1] or nick

local bday = etc.get('birthday', who)
if not bday then
  return nil, "Need a birthday"
end

local thisyear = os.date("%Y")
local nextyear = "" .. (tonumber(thisyear) + 1)

local thisyearbday = thisyear .. bday:sub(5)
local nextyearbday = nextyear .. bday:sub(5)

local thisyearbdaytime = etc.dateToTime(thisyearbday)
local nextyearbdaytime = etc.dateToTime(nextyearbday)

local upcomingbday = thisyearbday
local upcomingbdaytime = thisyearbdaytime

if os.time() >= thisyearbdaytime then
  upcomingbday = nextyearbday
  upcomingbdaytime = nextyearbdaytime
end

return upcomingbdaytime, upcomingbday,
  thisyearbdaytime, thisyearbday,
  nextyearbdaytime, nextyearbday
