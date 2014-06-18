if Editor then
  return
end

Web.header('Content-Type: application/json; charset=utf-8')

local _io = io

local io, password = ...
assert(type(io) == 'table' and io.open, 'etc.dbotfsbackend(io) required')
assert(password, 'need password')

local json = plugin.json()

function parseqs()
  local t = {}

  if Web.qs then
    for kv in Web.qs:sub(2):gmatch('[^&]+') do
      local k, v = kv:match('([^=]+)=(.+)')
      if k and v then
        t[k] = v
      else
        t[kv] = true
      end
    end
  end

  return t
end

function basename(path)
  return (path:match('([^/]+)$'))
end

function list(path, t)
  local ret = t or {}
  local seen = {}

  local function anus(ret, dir)
    ret[dir] = os.attributes(dir)
    ret[dir].children = {}
    for _, subpath in ipairs(os.list(dir)) do
      table.insert(ret[dir].children, basename(subpath))
    end
  end

  if path == '/' and not t then
    anus(ret, '/')
  end

  for _, dir in ipairs(os.list(path, 'd')) do
    list(dir, ret)
    anus(ret, dir)
  end

  for _, file in ipairs(os.list(path, 'f')) do
    ret[file] = os.attributes(file)
  end

  return ret
end

local Q = parseqs()

if Q.password ~= password then
  Web.write(json.encode{error = 'Wrong password'})
  return
end

if Q.command == 'files' then
  Web.write(json.encode(list('/')))
elseif Q.command == 'read' then
  assert(Q.path, 'need path')
  Q.path = urlDecode(Q.path)
  local f = assert(io.open(Q.path, 'r'))
  local data = f:read('*a')
  f:close()

  Web.write(data)
elseif Q.command == 'write' then
  assert(Q.path, 'need path')
  assert(Web.data, 'need post data')
  Q.path = urlDecode(Q.path)
  local f = assert(io.open(Q.path, 'w'))
  f:write(Web.data)
  f:close()
  Web.write(json.encode{status = 'OK'})
elseif Q.command == 'remove' then
  assert(Q.path, 'need path')
  Q.path = urlDecode(Q.path)
  os.remove(Q.path)
  Web.write(json.encode{status = 'OK'})
else
  Web.write(json.encode{
    error = 'invalid command'
  })
end
