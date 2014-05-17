-- Usage: Iterate through all the codepoints in a string. for cp in etc.codepoints("hello world") do ... end

local i = 1
local s = arg[1] or ""
local slen = s:len()

return function()
  local slen = slen
  if i > slen then
    return nil
  end
  local j = i + 1
  local s = s
  while j <= slen do
    local ch = s:sub(j, j)
    local bch = ch:byte()
    if 0x80 ~= bit.band(bch, 0xC0) then
      break
    end
    j = j + 1
  end
  local x = s:sub(i, j - 1)
  i = j
  return x
end

