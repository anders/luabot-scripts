-- 2012-05-21:
-- settings module, use like:
--   local settings = plugins.settings(io)
--   foo = settings.load('tz.aliases')
--   print(foo.bar)
--   foo.bar = 123
--   settings.save('tz.aliases', foo)
-- 2012-12-12:
--   made atomic

local io = arg[1]
if not io or not io.open then
  error('use plugin.settings(io)!')
end

local M = {}

local json = plugin.json()

function exists(f)
  return io.fs.attributes(f) ~= nil
end

function M.load(name)
  local ret = {}
  local f, e = io.open(name, 'r')
  if not f then return ret end
  local data = f:read()
  f:close()
  if data then
    ret = assert(json.parse(data))
  end
  return ret
end

function M.save(name, t)
  local tmpname = name
  if io.fs.rename and io.fs.remove then
    tmpname = name .. '.new'
  end
  assert(type(t) == 'table', 'expected table')
  local data = json.encode(t)
  assert(type(data) == 'string' and #data > 0, 'broken json output')
  local f = assert(io.open(tmpname, 'w'))
  f:write(data)
  f:close()
  if io.fs.rename and io.fs.remove then
    io.fs.remove(name)
    io.fs.rename(tmpname, name)
  end
end

return M