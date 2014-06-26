API "1.1"

local unicode = require "unicode"

local buf = {}

for cp in etc.codepoints(arg[1]) do
  local n = unicode.decode(cp)
  local desc = unicode.getUnicodeInfo(n)
  buf[#buf + 1] = ("U+%X %s"):format(n, desc)
end

return table.concat(buf, ", ")
