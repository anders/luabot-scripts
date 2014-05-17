local serializer = plugin.serializer()
local geocode = plugin.geocode()
local json = plugin.json()

local markers = serializer.load(io, 'markers.db')

if Web then
  Web.write('<!DOCTYPE html>\n')
  Web.write('<html>\n')
  Web.write('<head>\n')

  Web.write('<meta charset="utf-8">\n')
  Web.write('<meta name="viewport" content="initial-scale=1.0, user-scalable=no">\n')

  Web.write('<style type="text/css">\n')
  Web.write('html { height: 100% }\n')
  Web.write('body { height: 100%; margin: 0; padding: 0 }\n')
  Web.write('#map-canvas { height: 100% }\n')
  Web.write('</style>\n')
  
  Web.write('<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDBPZl8nzK2jwr15LCXycaIcx-M5A8Vjcs&sensor=false"></script>\n')
  
  Web.write('<script type="text/javascript">\n')
  
  local markerdata = {}
  for name, position in pairs(markers) do
    markerdata[#markerdata + 1] = {
      name = name,
      position = {position[1], position[2]}
    }
  end
  
  Web.write('var markers = '..json.encode(markerdata)..';\n')
  Web.write([[
  function initialize() {
    var mapOptions = {
      center: new google.maps.LatLng(55.87, 12.83),
      zoom: 3,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    
    for (var i = 0; i < markers.length; i++) {
      new google.maps.Marker({
        position: new google.maps.LatLng(markers[i].position[0], markers[i].position[1]),
        map: map,
        title: markers[i].name
      });
    }
  }
  google.maps.event.addDomListener(window, 'load', initialize);
  ]])
  Web.write('</script>\n')
  Web.write('</head>\n')
  
  Web.write('<body>\n<div id="map-canvas"></div>\n</body>\n')
  Web.write('</html>\n')

  return
end
--[[
local resp = assert(geocode.lookup(arg[1]))
return resp.formatted_address..' ('..resp.geometry.location.lat..', '..resp.geometry.location.lng..')'
]]

if arg[1] then
  local resp = geocode.lookup(arg[1])
  markers[nick:lower()] = {resp.geometry.location.lat, resp.geometry.location.lng}
  sendNotice(nick, 'marker updated!')
  serializer.save(io, 'markers.db', markers)
end

print(boturl..'u/'..getname(owner())..'/map.lua')