API "1.1"

local deck = arg[2] or _SaveThisGlobalDeckForReUse
if type(deck) ~= 'table' then
  deck = etc.getCardsIndexed(1, true, 'ordered')
  _SaveThisGlobalDeckForReUse = deck
end

local cardID = arg[1]
assert(type(cardID) == "number", "Expected card ID")

return deck[cardID]
