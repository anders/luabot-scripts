local date = arg[1] or ''
local year, month, day = date:match('(%d%d%d%d)-(%d%d)-(%d%d)')
if not year or not month or not day then
  return false, 'invalid format, use YYYY-mm-dd.'
end

if tonumber(year) < 1901 or tonumber(year) > 2038 then
  return false, 'invalid year, or unlikely.'
end

if tonumber(month) < 1 or tonumber(month) > 12 then
  return false, 'where I come from there are 12 months in a year.'
end

if tonumber(day) < 1 or tonumber(day) > 31 then
  return false, 'day out of bounds.'
end

local now = os.time()
if os.time{year=year, month=month, day=day} > os.time() then
  return false, 'are you John Titor?'
end

return date
