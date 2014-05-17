-- Usage: give me a string, I give you full width.

local s = arg[1] or ''
local t = {}
for i = 1, #s do
  local bc = string.byte(s, i, i)
  if bc == 32 then
    t[#t + 1] = '\227\128\128'
  elseif bc < 0x80 then
    t[#t + 1] = html2text("&#" .. (0xFEE0 + bc) .. ";")
  else
    t[#t + 1] = s:sub(i, i)
  end
end
return table.concat(t, "")
