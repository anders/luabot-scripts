API "1.1"

local unicode = require "unicode"


local expectedLength = {
  [1] = {0x0,     0x7f},
  [2] = {0x80,    0x7ff},
  [3] = {0x800,   0xffff},
  [4] = {0x10000, 0x10ffff},
}

local N = 100
if arg[1] then N = tonumber(arg[1]) end

local _rand = math.random
local function rand(a, b)
  local n = _rand(a, b)
  while n >= 0xd800 and n <= 0xdfff do
    n = _rand(a, b)
  end
  return n
end

for expect, range in ipairs(expectedLength) do
  for i=1, N do
    -- c will be a valid codepoint U+0000..10FFFF-1
    local c = rand(range[1], range[2])
    -- s will be c encoded as UTF-8
    local s = assert(unicode.encode(c))
    -- length of s must be equal to "expect"
    assert(#s == expect, c.." enc len: "..#s.."; expect: "..expect)
    -- round trip must match: decode(encode(c)) == c
    local cp = assert(unicode.decode(s))
    assert(cp==c, "cp="..cp..", c="..c..", mismatch")
  end
end
