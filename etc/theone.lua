local x = math.random() + math.random() + math.random() * 0.718281828459

local bestnick = nick
local bestone = x
local bestoffset = math.abs(1 - x)

local key = nick .. ".theone"
if not Cache[key] or math.abs(1 - Cache[key]) > bestoffset then
  Cache[key] = x
end

for k, v in pairs(Cache) do
  local curnick = k:match("^([^%.]+)%.theone$")
  if curnick then
    local offset = math.abs(1 - v)
    if offset < bestoffset then
      bestnick = curnick
      bestone = v
      bestoffset = offset
    end
  end
end

local function roundme(x)
  return math.floor(x * 1000000) / 1000000
end

print("Closest one to 1 wins. " .. nick .. "'s number is " .. roundme(x)
  .. " (" .. bestnick .. " is currently winning with " .. roundme(bestone) .. ")")
