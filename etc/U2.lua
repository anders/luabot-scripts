local unicode = require 'unicode'

-- returns character, description as two values
-- because 2 olde funcs expect c = etc.U(x, [fast]) to return a char
-- fast means don't look up unicode info, just return the char

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

local n, len
if type(s) == 'string' then
  n, len = assert(unicode.decode(assert(s, 'expected utf-8'), 1))
  if len - 1 < #s then
    -- input is longer than 1 codepoint, parse it as number
    s = s:gsub('^U?%+', '0x')
    if s:match('[a-fA-F0-9]+') then -- base 16
      n = tonumber(s, 16)
    elseif s:match('[0-9]+') then -- base 10
      n = tonumber(s)
    else
      -- maybe 2 codepoints, just use first one
    end
  end
elseif type(s) == 'number' then
  n = s
end

assert(n >= 0 and n <= 0x7FFFFFFF, 'out of range')
local c = unicode.encode(n)

if fast then return c end

local desc, cat = unicode.getUnicodeInfo(n)
if cat == 'Character not found' then cat = nil end -- hack

-- dont print control characters, but do allow private use chars
if cat and cat:sub(1, 1) == 'C' and cat ~= 'Co' then
  return '', ('U+%04X%s'):format(n, desc and ', ' .. desc or '')
else
  return c, ('(U+%04X%s)'):format(n, desc and ', ' .. desc or '')
end