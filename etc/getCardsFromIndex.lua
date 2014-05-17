-- Usage: takes a comma-separated list of card indices and reconstructs them into indexed cards. See also etc.getCardsIndexed and etc.getCardsToIndex

local deck = arg[2] or _SaveThisGlobalDeckForReUse
if type(deck) ~= 'table' then
  deck = etc.getCardsIndexed(1, true, 'ordered')
  _SaveThisGlobalDeckForReUse = deck
end
local cardstr = arg[1]
assert(type(cardstr) == "string", "Expected indexed cards string")

local result = {}
setmetatable(result, getmetatable(deck))
for cx in cardstr:gmatch("%d+") do
  local i = tonumber(cx)
  result[#result + 1] = deck[i]
end
return result
