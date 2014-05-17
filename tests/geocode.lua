local geocode = plugin.geocode()

res = assert(geocode.lookup(arg[1] or 'fabriksgatan 7 landskrona'))
for k, v in pairs(res) do print(k,'=',v) end