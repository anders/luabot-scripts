-- Converts numbers to decimal.

local s = etc.filterOutput(...) or ""

-- Hex without junk before it (e.g. don't pick up 3.0x10-1):
s = s:gsub("([^%d%.])(0[xX][0-9a-zA-Z%.]+)", function(a, x)
  return a .. x .. " (" .. (tonumber(x) or "nan") .. ")"
end)
-- Hex at start of text:
s = s:gsub("^(0[xX][0-9a-zA-Z%.]+)", function(x)
  return x .. " (" .. (tonumber(x) or "nan") .. ")"
end)

--[[ -- Floating-point precision problems:
local function sci(n, m)
  local x = string.format("%f", tonumber(n) * math.pow(10, m))
  x = x:gsub("%.0+$", "")
  return x
end
--]]
-- Work with strings:
local function sci(n, m)
  local r = {}
  local s = tostring(n)
  local dotpos = #s + 1
  for i = 1, s:len() do
    local ch = s:sub(i, i)
    if ch == '.' then
      dotpos = i
    else
      table.insert(r, ch)
    end
  end
  dotpos = dotpos + tonumber(m)
  if dotpos > #r then
    while dotpos > #r do
      table.insert(r, "0")
    end
  elseif dotpos < 1 then
    while dotpos < 1 do
      table.insert(r, 1, "0")
      dotpos = dotpos + 1
    end
  end
  if dotpos == 1 then
    table.insert(r, 1, "0")
    dotpos = dotpos + 1
  end
  --if dotpos < #r then
    table.insert(r, dotpos, ".")
  --end
  local x = table.concat(r)
  x = x:gsub("%.0+$", "")
  return x
end

s = s:gsub("(-?[%d%.]+)( *[\195\151x%*]+ *10 *^ *)(-?%d+)", function(a, b, c)
  -- print("a="..a..";b="..b..";c="..c)
  return a .. b .. c .. " (" .. sci(a, c) .. ")"
end)

s = s:gsub("(-?[%d%.]+)( *e *)(%+?-?%d+)", function(a, b, c)
  -- print("a="..a..";b="..b..";c="..c)
  return a .. b .. c .. " (" .. sci(a, c) .. ")"
end)

print(s)
