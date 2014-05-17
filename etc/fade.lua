local function getncolor(nc)
  local n = nc % 12
  nc = nc + 1
  if n == 0 then return 6 end
  if n == 1 then return 13 end
  if n == 2 then return 11 end
  if n == 3 then return 12 end
  if n == 4 then return 10 end
  if n == 5 then return 2 end
  if n == 6 then return 3 end
  if n == 7 then return 9 end
  if n == 8 then return 8 end
  if n == 9 then return 7 end
  if n == 10 then return 4 end
  if n == 11 then return 5 end
end

local bg = math.random(0, 11)
local fg = bg + 6
local s = arg[1] or ""
local result = ""
for i = 1, s:len() do
  local ch = s:sub(i, i)
  local sbg = tostring(getncolor(bg))
  local sfg = tostring(getncolor(fg))
  if sbg:len() == 1 then sbg = '0' .. sbg end
  if sfg:len() == 1 then sfg = '0' .. sfg end
  result = result .. '\003' .. sfg .. "," .. sbg .. ch
  bg = bg + 1
  fg = fg + 1
end
return result

