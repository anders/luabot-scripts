if Editor then
  return
end

if nick:lower() ~= getname(owner()):lower() then
  require 'spam'
  if spam.detect(Cache, 'more:'..nick, 4, 10) then
    error(nick..' has been Bot-lined.')
  end
end

local max_lines = 100
local max_size = 16384 --bytes

-- remove old cached output after 1d
local now = os.time()
local n = 0
for k, v in ipairs(os.list('more', 'f')) do
  local attr = os.attributes(v)
  if now >= attr.modification + 3600 * 24 then
    n = n + 1
    os.remove(v)
  end
end

--if n > 0 then
  --sendNotice(nick, n..' entries removed')
  --Output.maxLines = Output.maxLines - 1
--end

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
    Output.tty = not true
    local orig_max_lines = Output.maxLines
    Output.maxLines = max_lines
    local fn_out = fn(...)
    local fn_out_s = tostring(fn_out_s)
    Output.maxLines = orig_max_lines
    if fn_out ~= nil and #buffer + 1 <= max_lines and bytes + #fn_out_s + 1 <= max_size then
      buffer[#buffer + 1] = tostring(fn_out)
    end
    local b = buffer
    buffer = nil
    return b
  end
end

local input = arg[1]
local ret_output = arg[2]
local fn, args

if ret_output then
  local id = input
  local f = io.open('more/'..id, 'r')
  if not f then
    Web.write('enum { False, True, <b>FileNotFound</b> };')
    return
  end
  local data = f:read('*a')
  f:close()
  return data
elseif iscmd or type(input) == 'string' then
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
else
  if Web then
    local id = assert(Web.qs:match('%?id=(%w+)'))
    local output = etc.more(id, true)
    if output then
      output = output:gsub('[^\n]+', function(line)
        return irc2html(line)
      end)
      Web.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><link rel="stylesheet" href="more.css" charset="utf-8"><title>more.lua</title></head><body><pre>'..output..'</pre></body></html>')
    end
    return
  else
    error('unexpected input type')
  end
end

local out = get_output(fn, unpack(args or {}))
if #out <= Output.maxLines then
  print(table.concat(out, '\n'))
else
  local alphabet = --[['ABCDEFGHIJKLMNOPQRSTUVWXYZ']]'abcdefghijklmnopqrstuvwxyz0123456789'
  local id = {}
  for i=1, 8 do
    id[i] = string.char(alphabet:byte(math.random(1, #alphabet)))
  end
  id = table.concat(id, '')

  local f = assert(io.open('more/'..id, 'w'))
  f:write(table.concat(out, '\n'))
  f:close()
  
  for i=1, Output.maxLines - 1 do
    print(out[i])
  end

  local me = getname(owner())
  print('...more: '..boturl..'u/'..me..'/more.lua?id='..id)
end
