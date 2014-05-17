local julday = function(year, month, day)
	if year < 0 then year = year + 1 end
	local jy = year
	local jm = month + 1
	if month <= 2 then jy = jy - 1 end -- jm+= 12
	local jul = math.floor(365.25 * jy) + math.floor(30.6001 * jm) + day + 1720995
	if day+31*(month+12*year) >= 15+31*(10+12*1582) then
		ja = math.floor(0.01 * jy)
		jul = jul + 2 - ja + math.floor(0.25 * ja)
	end
	return jul
end

-- js approximation xD
local newDate = function(year, month, day, hours, minutes, seconds, milliseconds)
	local time = os.time{year=year, month=month, day=day, hour=hours, min=minutes, sec=seconds}
	return {getTime = function() return time * 1000 end}
end

local Simple = function(year, month, day)
	local lp = 2551443
	local now = newDate(year,month-1,day,20,35,0)		
	local new_moon = newDate(1970, 0, 7, 20, 35, 0)
	local phase = ((now:getTime() - new_moon:getTime()) / 1000) % lp
	return math.floor(phase / (24*3600)) + 1
end

d = os.date('!*t')
year,month,day = d.year, d.month, d.day
print(Simple(year, month, day))