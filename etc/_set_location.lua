local geocode = require 'geocode'
local json = require 'json'

local loc, setinfo = ...

local res, err = geocode.lookup(loc)
local extra = {}
if res then
  local lat, lon = res.geometry.location.lat, res.geometry.location.lng

  local tzinfo = httpGet('https://onyx-sequencer-833.appspot.com/tzapi/coord2tz?lat='..lat..'&lon='..lon)
  if tzinfo and tzinfo:byte(1) == 123 then
    local tz = json.decode(tzinfo)
    extra.timezone = tz.timeZoneId
  end

  extra['location.coords'] = lat..','..lon
  -- TODO: maybe override using the geocoded name from Google
end

--[[
if not setinfo.god then
  sendNotice(setinfo.user, "If you want to set your locale settings then do 'set locale en_US etc xD")
end
]]

return loc, extra
