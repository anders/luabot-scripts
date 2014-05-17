if arg[1] then
  local a, b = botstock(arg[1])
  if a then
    return b .. " at $" .. a
  end
  return a, b
end

local symbols = botstockValues()

local url = boturl .. "t/botstock?q="
local needplus = false
local tot = 0
local nsyms = 0
for k, v in pairs(symbols) do
  tot = tot + v
  nsyms = nsyms + 1
  if needplus then
    url = url .. "+"
  end
  needplus = true
  url = url .. k
end
return "Average at $" .. math.floor(tot / nsyms), url
