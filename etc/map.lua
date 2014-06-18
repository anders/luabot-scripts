-- 2014-06-13: nicklist() broken in Web

--[[

local s = ...
if #s == 0 then
  return etc.marker()
else
  return 'https://maps.google.com/?q='..urlEncode(s)
end

]]

local geocode = plugin.geocode()
local json = plugin.json()

if Web then
  -- local chan = Web.GET.chan or '#clowngames'

  Web.write('<!DOCTYPE html>\n')
  Web.write('<html>\n')
  Web.write('<head>\n')

  Web.write('<meta charset="utf-8">\n')
  Web.write('<meta name="viewport" content="initial-scale=1.0, user-scalable=no">\n')

  Web.write('<style type="text/css">\n')
  Web.write('html { height: 100% }\n')
  Web.write('body { height: 100%; margin: 0; padding: 0 }\n')
  Web.write('</style>\n')
  
  Web.write('<script type="text/javascript" src="//maps.googleapis.com/maps/api/js?key=AIzaSyDBPZl8nzK2jwr15LCXycaIcx-M5A8Vjcs&sensor=false"></script>\n')
  Web.write('<script src="//google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclustererplus/src/markerclusterer_packed.js"></script>')
  Web.write('</head><body>\n')
  Web.write('<div id="map" style="width: 100%; height: 100%"></div>')
  Web.write('<script type="text/javascript">\n')
  
  local markerdata = {}
  for k, v in ipairs(os.list("uvars")) do
    v = v:match("uvars/([^.]+).json")
    local pos = etc.get('location.coords', v)
    if pos then
      local lat, lon = pos:match('([^,]+),([^,]+)')
      markerdata[#markerdata + 1] = {
        account = v,
        formattedAddress = etc.get('location', v) or 'N/A',
        lng = tonumber(lon),
        lat = tonumber(lat),
        network = 'freenode'
      }
    end
  end
  
  Web.write([[
  var map = new google.maps.Map(document.getElementById("map"), {
    center: new google.maps.LatLng(0, 0),
    zoom: 3
  });
  var infoWindow = null;
  var markers = [];
  
  function makeInfoWindow(info) {
    return new google.maps.InfoWindow({
      content: makeMarkerDiv(info)
    });
  }
  
  function makeMarkerDiv(h) {
    return "<div style='line-height:1.35;overflow:hidden;white-space:nowrap'>" + h + "</div>";
  }
  
  function makeMarkerInfo(m) {
    return "<strong>" + m.get("account") + " on " + m.get("network") + "</strong> " +
      m.get("formattedAddress");
  }
  
  function dismiss() {
    if (infoWindow !== null) {
      infoWindow.close();
    }
  }
  ]])
  
  
  --[[{
    "account": "rfw",
    "formattedAddress": "Pyrmont NSW, Australia",
    "lng": 151.1945404,
    "network": "freenode",
    "lat": -33.8695456
  }]]
  
  Web.write(json.encode(markerdata)..[[.forEach(function (loc) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(loc.lat, loc.lng)
    });
    marker.setValues(loc);
    markers.push(marker);
    google.maps.event.addListener(marker, "mouseover", function () {
      dismiss();
      infoWindow = makeInfoWindow(makeMarkerInfo(marker));
      infoWindow.open(map, marker);
    });
    google.maps.event.addListener(marker, "mouseout", dismiss);
    google.maps.event.addListener(marker, "click", function () {
      map.setZoom(Math.max(8, map.getZoom()));
      map.setCenter(marker.getPosition());
    });
  });
  var mc = new MarkerClusterer(map, markers, {
    averageCenter: true
  });
  google.maps.event.addListener(mc, "mouseover", function (c) {
    dismiss();
    var markers = c.getMarkers();
    infoWindow = makeInfoWindow(markers.map(makeMarkerInfo).join("<br>"));
    infoWindow.setPosition(c.getCenter());
    infoWindow.open(map);
  });
  google.maps.event.addListener(mc, "mouseout", dismiss);
  google.maps.event.addListener(mc, "click", dismiss);
  
  ]])
  
  
  
  --Web.write('var markers = '..json.encode(markerdata)..';\n')
  --[===[Web.write([[
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
  ]])]===]
  Web.write('</script>\n')
  
  Web.write('</body>\n')
  Web.write('</html>\n')

  return
end

--[[
local resp = assert(geocode.lookup(arg[1]))
return resp.formatted_address..' ('..resp.geometry.location.lat..', '..resp.geometry.location.lng..')'
]]

print(boturl..'u/'..getname(owner())..'/map.lua?chan='..urlEncode(assert(chan, 'chan nil?')))
