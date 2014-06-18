local sep = '/' -- should be arg[1]:sub(1, 1) later I suppose (must escape for lua patterns)
local pattern = ('ROFL([^ROFL]+)ROFL([^ROFL]*)ROFL?([ig]?)'):gsub('ROFL', sep)
local search, replace, flags = arg[1]:match(pattern)

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
