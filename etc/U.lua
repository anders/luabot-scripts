 local LOG = plugin.log(_funcname)

-- Temporary:

local hist = _getHistory(0) or ""
if hist:sub(1, 2) == "'u" then
  print "'u is deprecated, please use 'user instead."
  print(etc.user(...) or "")
  return
end

--- U(codepoint, fast?) -> UTF-8 encoded codepoint; description
--- @param fast don't look up character info in the Unicode database

local unicode = require 'unicode'

-- initialize important subsystem
plugin._april_fools()

local s, fast = ...

if not s or Help then
  local suggestions = {
    '7CDE',
    '1F4A9'
  }
  local suggestion = suggestions[math.random(1, #suggestions)]
  print('Usage: Supply a unicode character or a U+NNNN code point for awesome information, example \'U+'..suggestion)
  return
end

local plainTextSearch = false

local n, len
if type(s) == 'string' then
  if #s > 4 and s:sub(1, 1) ~= '+' then
    n = unicode.findByDescription(s:upper(), plainTextSearch)
    if not n then
      return false, "Couldn't find any character matching that description."
    end
  else
    local c, len = assert(unicode.decode(assert(s, 'expected UTF-8'), 1))
    if len - 1 < #s then
      -- input is longer than 1 codepoint, parse it as number
      s = s:gsub('^U?%+', '0x')
      if s:match('[a-fA-F0-9]+') then -- base 16
        n = tonumber(s, 16)
      end
      
      if not n then
        n = unicode.findByDescription(s:upper(), plainTextSearch)
        if not n then
          return false, "Couldn't find any character matching that description."
        end
      end
    end
    
    if not n then n = c end
  end
elseif type(s) == 'number' then
  n = s
end

assert(n >= 0 and n <= 0x7FFFFFFF, 'out of range')
local c = unicode.encode(n)

if fast then return c end

local desc, cat = unicode.getUnicodeInfo(n)
if cat == 'Character not found' then cat = nil end -- hack

-- Don't print control characters, but do allow private use chars.
if cat and cat:sub(1, 1) == 'C' and cat ~= 'Co' then
  return '', ('U+%04X%s'):format(n, desc and ', ' .. desc or '')
else
  return c, ('(U+%04X%s)'):format(n, desc and ', ' .. desc or '')
end
