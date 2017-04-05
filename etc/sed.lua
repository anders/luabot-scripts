local escape = {}
local special = "().%+-*?[^$"
for i=1, #special do
  escape[special:sub(i, i)] = "%"..special:sub(i, i)
end

local sep = arg[1]:sub(1, 1)
sep = escape[sep] or sep

local pattern = ('ROFL([^ROFL]+)ROFL([^ROFL]*)ROFL?([ig]?)'):gsub('ROFL', function() return sep end)
local search, replace, flags = arg[1]:match(pattern)
if not search then
  print(("%s * couldn't match sed pattern, got nilly. sep=%q, pat=%q"):format(nick, sep, pattern))
  return
end

if flags:find('i') then
  search = etc.cipat(search) -- case insensitive
end

local n = 1

while true do
  local line, nick = _getHistory(n)
  if not line then break end

  line = etc.stripCodes(line)
  
  if not line:find(etc.cmdprefix..'se?d?[^%w]') and line:match(search) then
    line = line:gsub('\031', '') -- strip underline
    
    -- if the line begins with <luabot> strip that
    if nick == bot then
      local _, to = line:find('^<'..bot..'> ')
      if to then
        line = line:sub(to + 1)
      end
    end
    
    print('<'..nick..'> '..(line:gsub(search, '\031'..replace..'\031', not flags:find('g') and 1 or nil)))
    return
  end

  n = n + 1
end
