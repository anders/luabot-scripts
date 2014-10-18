API "1.1"

local index = arg[1]
assert(type(index) == "number" and index > 0, "Invalid card index")
index = (index - 1) % (54) + 1

local suits = { 'c', 'd', 'h', 's' }
local suit = suits[math.floor((index - 1) / 13) + 1]
local value = math.floor((index - 1) % 13 + 1)
local cardMT = {
  __tostring = _cardsString,
}
local card

if not suit then
  if value == 1 then
    suit = 'h'
  elseif value == 2 then
    suit = 's'
  end
  value = '*'
  card = _createCard(value, suit)
else
  if value == 1 then
    value = 'a'
  elseif value == 11 then
    value = 'j'
  elseif value == 12 then
    value = 'q'
  elseif value == 13 then
    value = 'k'
  end
  card = _createCard(tostring(value), suit)
end

card.index = index
return setmetatable(card, cardMT)

--[[ -- Old way that gets confused by multiple decks and jokers.
local deck = arg[2] or _SaveThisGlobalDeckForReUse
if type(deck) ~= 'table' then
  deck = etc.getCardsIndexed(1, true, 'ordered')
  _SaveThisGlobalDeckForReUse = deck
end

local cardID = arg[1]
assert(type(cardID) == "number", "Expected card ID")

return deck[cardID]
--]]
