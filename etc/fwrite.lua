arg[1] = arg[1] or ''

local path, data = arg[1]:match('([^%s]+) (.+)')
if not path or not data then
  print("Usage: 'fwrite /path/to/file data")
  return
end

local f, e = io.open(path, 'w')
if not f then
  print("Error: "..e)
  return
end

f:write(data)
f:close()

local pubweb = '/pub/web/'
if path:sub(1, #pubweb) == pubweb then
  print('Done. '..boturl..'u/'..nick..'/'..path:sub(10))
end
