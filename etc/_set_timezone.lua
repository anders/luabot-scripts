do return false, 'Use \'set location instead' end

local tz = arg[1] or ''

local function exists(fn)
  local f = io.open(fn, 'r')
  if not f then return false end
  f:close() return true
end

if --[[not os.attributes('/shared/zoneinfo/'..tz)]] not exists('/shared/zoneinfo/'..tz) then
  return false, 'No such zoneinfo file.'
end

return tz
