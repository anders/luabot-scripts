-- Usage: takes indexed cards and returns a comma-separated list of card indices which can be reconstructed into cards. See also etc.getCardsIndexed and etc.getCardsFromIndex

local cards = arg[1]
assert(type(cards) == "table" and (#cards == 0 or cards[1].index), "Expected indexed cards")

local result = ""
for i, c in ipairs(cards) do
  if i > 1 then
    result = result .. ','
  end
  result = result .. c.index
end
return result
