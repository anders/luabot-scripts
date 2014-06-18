local geocode = plugin.geocode()
local resp = assert(geocode.lookup(arg[1]))
return resp.formatted_address..' ('..resp.geometry.location.lat..', '..resp.geometry.location.lng..')'
