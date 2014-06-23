-- arg[1] is a sentence, arg[2] is max characters

if not arg[1] then
  return
end

local s = arg[1]
local max = arg[2] or Output.maxLineLength or 400

local origlen = s:len()
if origlen > max then
  if max < 3 then
    -- Wasn't enough room for ellipse.
    return ("..."):sub(1, max)
  end
  local bufz = math.floor(max / 4)
  if bufz > 12 then
    bufz = 12
  elseif bufz < 3 then
    bufz = 3
  end
  local aa = s:sub(1, max - bufz)
  local bb = s:sub(max - bufz + 1):match("^[^,%.! %-]*"):sub(1, bufz - 3)
  -- print("aa=", aa, "bb=", bb)
  s = aa .. bb .. "..."
end

return s
