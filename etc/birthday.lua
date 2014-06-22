local input = (arg[1] or nick):match('[^%s]+')
local birthday = etc.get('birthday', input)

if not birthday then
  if input:upper() == nick:upper() then
    return false, 'set your birthday with \'set birthday YYYY-mm-dd'
  else
    return false, "sorry, don't know their birthday"
  end
end

local year, month, day = birthday:match('(%d%d%d%d)-(%d%d)-(%d%d)')
if not year or not month or not day then
  return "sorry, don't know their birthday"
end

local now = os.time()
local bdayts = os.time{year=year, month=month, day=day, hour=0}
local t = os.date('!*t', bdayts)

local diff = os.difftime(now, bdayts)
local years = diff / 3600 / 24 / 365.242
local gs = diff / 1000000000

local months = {
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December'
}

print(('%s was born on %s %d, %d (%d years, %0.2f Gs ago)'):format(input, months[t.month], t.day, t.year, years, gs))
