local M = {}

local function _loadtz(zone)
  zone = zone:match('([^.]+)')
  local f, e = io.open('/shared/zoneinfo/'..zone, 'r')
  if not f then return false, e end
  
  local tzdata = f:read('*a')
  f:close()
  
  local fn = assert(guestloadstring('return '..tzdata))
  return fn()
end
--[[
local function _loadtz()
  --print('WARNING: using fake _loadtz() with hardcoded data!')
  return { version='2013d', zone = 'Europe/Stockholm/FAKE',
    {ts=1351386000, dst=false, name='CET', ut_offset=3600},
    {ts=1364691600, dst=true, name='CEST', ut_offset=7200},
    {ts=1382835600, dst=false, name='CET', ut_offset=3600},
    {ts=1396141200, dst=true, name='CEST', ut_offset=7200},
    {ts=1414285200, dst=false, name='CET', ut_offset=3600},
    {ts=1427590800, dst=true, name='CEST', ut_offset=7200},
    {ts=1445734800, dst=false, name='CET', ut_offset=3600}
  }
end
]]
-- time.zoneinfo(zone, [timestamp])
-- for a given zone and optional ts, return:
-- {'offset': number (seconds),
--  'code': string,
--  'dst': boolean,
--  'localtime': number}
function M.zoneinfo(zone, ts)
  assert(zone, 'zoneinfo(zone, [timestamp]')
  ts = ts or os.time()
  
  local tz, e = _loadtz(zone)
  if not tz then return false, e end

  local a = 1
  local b = #tz
  while a <= b do
    local c = math.floor((a + b) / 2)
    if tz[c].ts > ts then
      b = c - 1
    else
      a = c + 1
    end
  end
  
  return {
    zone = tz.zone,
    code = tz[b].name,
    offset = tz[b].ut_offset,
    dst = tz[b].dst,
    localtime = ts + tz[b].ut_offset
  }
end

return M

