API "1.1"

local Time = require 'time'
local unicode = require 'unicode'
local now = os.time()
local nowT = os.date("!*t", now)

--1=formatted time
--2=offset
--3=tz code
--4=table {hour=12, min=43, wday=3, day=18, month=4, year=2017, sec=26, yday=108, isdst=false}
local userTz = {etc.timezone(nick, nil, nil, true)}
if not userTz[1] then
  userTz = {"...", 0, "UTC", os.date("!*t")}
end

local marketInfo = {
  --[[
  NASDAQ = { tz = "America/New_York",  hours = { 0900, 1600 }, country = "us", },
  NYSE =   { tz = "America/New_York",  hours = { 0900, 1600 }, country = "us", },
  ]]
  US  =    { tz = "America/New_York",  hours = { 0930, 1600 }, country = "us", },
  TSX =    { tz = "America/Toronto",   hours = { 0930, 1600 }, country = "ca", },
  LSE =    { tz = "Europe/London",     hours = { 0800, 1630 }, country = "gb", },
  STO =    { tz = "Europe/Stockholm",  hours = { 0900, 1730 }, country = "se", },
  CPH =    { tz = "Europe/Copenhagen", hours = { 0900, 1700 }, country = "dk", },
  TSE =    { tz = "Asia/Tokyo",        hours = { 0900, 1500 }, country = "jp",
                                       lunch = { 1130, 1230 }, },
  OSL =    { tz = "Europe/Oslo",       hours = { 0900, 1630 }, country = "no", },
  FIN =    { tz = "Europe/Helsinki",   hours = { 1000, 1830 }, country = "fi", },
}

-- [year][month][day][market] = false or {open, close}
local specialDates = {
  [2017] = {
    [05] = {
      [24] = {
        STO = { 0900, 1300 },
      },
    },
    [07] = {
      [03] = {
        US = { 0930, 1300 },
      },
    },
    [11] = {
      [03] = {
        STO = { 0900, 1300 },
      },
      [24] = {
        US = { 0930, 1300 },
      },
    },
  },
}

--[[
LSE Holidays:
  New Year's Day,
  Good Friday,
  Easter Monday,
  May Bank Holiday,
  Spring Bank Holiday,
  Summer Bank Holiday,
  Christmas Day.
]]

local holidays = {
  -- yearly
  {   -1, 05, 01, { "STO", "OSL", "FIN", "LSE", } }, -- Worker's Day
  {   -1, 05, 17, { "OSL" } },                       -- Norwegian National Day
  {   -1, 06, 06, { "STO" } },                       -- Swedish National Day
  {   -1, 07, 04, { "US" } },            -- May the 4th be with you
                                                     -- Christmas Day
  {   -1, 12, 25, { "US", "TSX", "STO", "CPH", "OSL", "FIN", "LSE", } },
                                                     -- Boxing Day(?)
  {   -1, 12, 26, {       "TSX", "STO", "CPH", "OSL", "FIN", "LSE", } },

  -- TODO: yearly ones, move them
  -- TODO: generate this list automatically
  { 2017, 04, 17, { "STO", "CPH", "OSL", "FIN", "LSE", } },
  { 2017, 05, 12, { "CPH" } },
  { 2017, 05, 22, { "TSX" } },
  { 2017, 05, 25, { "STO", "CPH", "OSL", "FIN" } },
  { 2017, 05, 29, { "US" } },
  { 2017, 06, 05, { "OSL", "CPH" } },
  { 2017, 06, 23, { "STO", "FIN" } },
  { 2017, 08, 07, { "TSX" } },
  { 2017, 09, 04, { "TSX" } },
  { 2017, 10, 04, { "US" } }, -- Labor Day
}

for _, t in ipairs(holidays) do
  local y, m, d, markets = t[1], t[2], t[3], t[4]
  if y < 0 then
    y = nowT.year
  end
  specialDates[y] = specialDates[y] or {}
  specialDates[y][m] = specialDates[y][m] or {}
  specialDates[y][m][d] = specialDates[y][m][d] or {}
  for _, market in ipairs(markets) do
    specialDates[y][m][d][market] = true
  end
end

local markets = { "US", "TSX", "LSE", "STO", "CPH", "OSL", "FIN", "TSE" }

-- hm(0930) -> return 9, 30
local function hm(t)
  local m = t % 100
  local h = (t - m) / 100
  return h, m
end

local function flagSymbol(az)
  az = az:upper()
  local c = az:byte()
  if c < 65 or c > 90 then return "" end
  c = c - 65
  return unicode.encode(0x1F1E6 + c)
end

local function flagEmoji(country_code)
  return flagSymbol(country_code:sub(1, 1)) .. flagSymbol(country_code:sub(2, 2))
end

local getTimezone
do
  local alias = {
    ["America/Toronto"]   = "America/New_York",
    ["Europe/Copenhagen"] = "Europe/Stockholm",
    ["Europe/Helsinki"]   = "Europe/Stockholm",
    ["Europe/Oslo"]       = "Europe/Stockholm",
  }
  local cached = {}
  function getTimezone(path, time)
    time = time or os.time()
    path = alias[path] or path
    if cached[path] then return cached[path] end
    local tz, err = Time.zoneinfo(path, time)
    if not tz then return tz, err end
    cached[path] = tz
    return tz
  end
end

local buf = {}
for _, market in ipairs(markets) do
  local m = assert(marketInfo[market])
  
  local tz = assert(getTimezone(m.tz))
  local t = os.date("!*t", now + tz.offset)
  local localNow = os.time(t)
  
  local function localhm(h, m)
    
  end
  
  local open = true
  local holiday = false
  local weekend = false
  local lunch = false
  
  -- sunday? saturday?
  if t.wday == 1 or t.wday == 7 then
    holiday = true
    weekend = true
  end

  local openHour, openMinute   = hm(m.hours[1])
  local closeHour, closeMinute = hm(m.hours[2])
  
  local lunchCloseHour, lunchCloseMin
  local lunchOpenHour, lunchOpenMin
  
  if m.lunch then
    lunchCloseHour, lunchCloseMin = hm(m.lunch[1])
    lunchOpenHour, lunchOpenMin   = hm(m.lunch[2])
  end
  
  if holiday then
    open = false
  else
    local special = specialDates[t.year]
    if special then
      special = special[t.month]
      if special then
        special = special[t.day]
        if special then
          local s = special[market]
          if s == true then
            holiday = true
            open = false
          elseif type(s) == "table" then
            openHour, openMinute   = hm(s[1])
            closeHour, closeMinute = hm(s[2])
          end
        end
      end
    end

    if not holiday then
      local tmp = {
        year = t.year, month = t.month, day = t.day,
        isdst = t.isdst,
      }
      tmp.hour = openHour
      tmp.min  = openMinute
      local openTime = os.time(tmp)
      
      tmp.hour = closeHour
      tmp.min  = closeMinute
      local closeTime = os.time(tmp)
      
      status = localNow >= openTime and localNow <= closeTime

      if m.lunch and status then
        tmp.hour = lunchCloseHour
        tmp.min  = lunchCloseMin
        local lunchCloseTime = os.time(tmp)
        
        tmp.hour = lunchOpenHour
        tmp.min  = lunchCloseMin
        local lunchOpenTime  = os.time(tmp)
        
        status = not (localNow >= lunchCloseTime and localNow <= lunchOpenTime)
        lunch = not status
      end
    else
      status = false
    end
  end
  
  local tmp = ""
  if not status and lunch then
    tmp = " (lunch)"
  elseif holiday and not weekend then
    tmp = " (holiday)"
  end
  local flag = ""
  if m.country then
    flag = flagEmoji(m.country).." "
  end
  
  local openStr = ("open %02d:%02d-%02d:%02d"):format(openHour, openMinute, closeHour, closeMinute)
  if m.lunch then
    openStr = openStr..(", lunch %02d:%02d-%02d:%02d"):format(lunchCloseHour, lunchCloseMin, lunchOpenHour, lunchOpenMin)
  end
  
  local closedStr = ("closed, opens %02d:%02d"):format(openHour, openMinute)
  
  buf[#buf + 1] = ("%s\2%s\2: %s%s"):format(flag, market, status and openStr or closedStr, tmp)
end

local longOutput = Editor or network == "Telegram"
return table.concat(buf, longOutput and "\n" or ", ")
