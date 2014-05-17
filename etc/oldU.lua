local x = arg[1]
local n
if type(x) == "number" then
  n = x
  x = string.format("%x", x)
elseif type(x) == "string" then
  n = tonumber(x, 16)
  if not n then
      x = nil
  end
  -- x = string.format("%x", x)
else
  x = nil
end
assert(x, "Unicode codepoint value expected")
return html2text("&#x" .. x .. ";")
