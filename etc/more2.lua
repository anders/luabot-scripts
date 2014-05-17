local max_lines = 100
local max_size = 16384 --bytes

-- remove old cached output after 24h
local now = os.time()
for k, v in ipairs(os.list('more', 'f')) do
  local attr = os.attributes(v)
  if now >= attr.modification + 3600 * 24 then
    os.remove(v)
  end
end

do
  local _print = print
  local buffer
  local buffering = false
  local bytes = 0

  function print(...)
    if not buffer then
      return _print(...)
    end
    
    local tmp = {}
    for i=1, select('#', ...) do
      tmp[i] = tostring(select(i, ...))
    end
    
    local s = table.concat(tmp, ' ')
    local n = #s + 1 -- \n
    if bytes + n <= max_size and #buffer + 1 <= max_lines then
      bytes = bytes + n
      buffer[#buffer + 1] = s
    end
  end

  function get_output(fn, ...)
    buffer = {}
    bytes = 0
    local fn_out = fn(...)
    local fn_out_s = tostring(fn_out_s)
    if fn_out ~= nil and #buffer + 1 <= max_lines and bytes + #fn_out_s + 1 <= max_size then
      buffer[#buffer + 1] = tostring(fn_out)
    end
    local b = buffer
    buffer = nil
    return b
  end
end

local input = arg[1]
local fn, args

if iscmd or type(input) == 'string' then
  assert(input, 'expected input')
  local cmd, extra = input:match("'(%w+) ?(.*)")
  assert(cmd, 'expected command')
  if #extra > 0 then
    args = {extra}
  end
  
  fn = etc[cmd]
  assert(fn, 'no such function in etc')
elseif type(input) == 'function' then
  fn = input
  args = {...}
  table.remove(args, 1)
elseif type(input) == 'number' then
  local id = input
  local f = assert(io.open('more/'..id, 'r'), id)
  local data = f:read('*a')
  f:close()
  return data
else
  if Web then
    local id = assert(Web.qs:match('%?id=(%d+)'))
    id = tonumber(id)
    print(etc.more2(id))
    return
  else
    error('unexpected input type')
  end
end

local out = get_output(fn, unpack(args or {}))
if #out <= 4 then
  print(table.concat(out, '\n'))
else
  local id = Cache.more_id or 1
  Cache.more_id = id + 1

  local f = assert(io.open('more/'..id, 'w'))
  f:write(table.concat(out, '\n'))
  f:close()
  
  for i=1, 3 do
    print(out[i])
  end

  local me = getname(owner())
  print('output continued at '..boturl..'u/'..me..'/more.lua?id='..id)
end
