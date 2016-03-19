if Editor then
  return
end

if Web then
  local id = assert(Web.qs:match('%?id=(%w+)'))
  local f = io.open('less/'..id, 'r')
  if not f then
    Web.write('enum { False, True, <b>FileNotFound</b> };')
    return
  end
  local output = f:read('*a')
  f:close()
  if output then
    output = output:gsub('[^\n]+', function(line)
      return irc2html(line)
    end)
    -- Web.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><link rel="stylesheet" href="/u/anders/more.css" charset="utf-8"><title>less.lua</title></head><body><pre>'..output..'</pre></body></html>')
    -- Web.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>less.lua</title></head><body><tt>' .. output:gsub("\n", "<br>\n") .. '</tt></body></html>')
    Web.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>less.lua</title></head><body style="margin: 4px"><pre style="white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word">' .. output .. '</pre></body></html>')
  end
  return
end

if nick:lower() ~= getname(owner()):lower() then
  require 'spam'
  if spam.detect(Cache, 'less:'..nick, 2, 5) then
    error(nick..' has been Bot-lined.')
  end
end

local LOG = plugin.log(_funcname)

os.mkdir("less")

local max_lines = 100
local max_size = 16384 --bytes

-- remove old cached output after 1d
local now = os.time()
local n = 0
for k, v in ipairs(os.list('less', 'f')) do
  local attr = os.attributes(v)
  if now >= attr.modification + 3600 * 24 then
    n = n + 1
    os.remove(v)
    LOG.trace("removed expired file", v)
  end
end

local data = arg[1] or ''
if #data > max_size then
  LOG.trace("crop data from", #data, "to", max_size, "bytes")
  data = data:sub(1, max_size)
end

local lnd = {}
for ln in data:gmatch("([^\n]*)\n?") do
  if #ln < max_lines then
    lnd[#lnd + 1] = ln
  else
    LOG.trace("dropping lines after line #", #ln)
    break
  end
end

if #lnd > Output.maxLines - 1 then
  LOG.trace("too many lines to fit in output,", #lnd, "lines > max", Output.maxLines)
  local alphabet = --[['ABCDEFGHIJKLMNOPQRSTUVWXYZ']]'abcdefghijklmnopqrstuvwxyz0123456789'
  local id = {}
  for i=1, 8 do
    id[i] = string.char(alphabet:byte(math.random(1, #alphabet)))
  end
  id = table.concat(id, '')

  local f = assert(io.open('less/'..id, 'w'))
  f:write(data)
  f:close()
  
  for i=1, Output.maxLines - 1 do
    print(lnd[i])
  end

  local me = getname(owner())
  print('...less: '..boturl..'u/'..urlEncode(me)..'/less.lua?id='..id)
else
  LOG.trace("directly outputting", #lnd, "lines <= max", Output.maxLines)
  return data
end
