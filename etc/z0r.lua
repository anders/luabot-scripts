if not Cache.lastz0r then
  local data, err = httpGet('http://z0r.de/0')
  assert(data, err)
  
  local _, _, last = data:find('<a href="(%d+)">&laquo; Previous</a>')
  Cache.lastz0r = last
end
print('http://z0r.de/'..math.random(0, Cache.lastz0r))