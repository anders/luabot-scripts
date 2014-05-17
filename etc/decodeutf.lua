local bit = require 'bit'
local shl, band, bor = bit.lshift, bit.band, bit.bor

local function codepoint(s)
  local c, n = s:byte(1)
  local width = 1 -- length of utf8 cp in bytes

  local function check(n)
    assert(#s >= n, 'incomplete codepoint ('..#s..' >= '..n..')')
    for i=2, n do
      assert(band(s:byte(i), 0xC0) == 0x80, 'expected continuation byte at '..i)
    end
  end

  if c <= 0x7f then
    n = c
  elseif band(c, 0xE0) == 0xC0 then
    width = 2
    check(2)
    n = shl(band(c, 0x1F), 6)
    n = bor(n, band(s:byte(2), 0x3F))
  elseif band(c, 0xF0) == 0xE0 then
    width = 3
    check(3)
    n = shl(band(c, 0x0F), 12)
    n = bor(n, shl(band(s:byte(2), 0x3F), 6))
    n = bor(n, band(s:byte(3), 0x3F))
  elseif band(c, 0xF8) == 0xF0 then
    width = 4
    check(4)
    n = shl(band(c, 0x07), 15)
    n = bor(n, shl(band(s:byte(2), 0x3F), 12))
    n = bor(n, shl(band(s:byte(3), 0x3F), 6))
    n = bor(n, band(s:byte(4), 0x3F))
  end
  return n, width, s:sub(1, width)
end

local s = ...

local decoded = {}
local start, left = 1, #s
while true do
  local cp, w = codepoint(s:sub(start))
  decoded[#decoded + 1] = cp
  left = left - w
  start = start + w
  if left < 1 then break end
end

return decoded