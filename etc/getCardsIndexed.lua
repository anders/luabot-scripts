-- Usage: gets cards with an index, see also etc.getCardsOrdered and etc.getCardsFromIndex

local cards, err = etc.getCardsOrdered(...)

if type(arg[1]) == "table" then
  assert(#cards == 0 or cards[1].index, "Did not find cards with index")
else
  for i = 1, #cards do
    cards[i].index = i
  end
  if arg[3] == 'ordered' then
    return cards, err
  end
  -- Randomize the order of the cards if the cards weren't provided as a table.
  -- math.randomseed(seed)
  require("RandomLua")
  local r = RandomLua.mwc()
  for i = 1, #cards do
    -- local j = math.random(#cards)
    local j = r:random(#cards)
    cards[i], cards[j] = cards[j], cards[i]
  end
end

return cards, err
