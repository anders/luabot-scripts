-- Usage: gets cards, see also etc.getCardsOrdered and etc.getCardsIndexed

local cards, err = etc.getCardsOrdered(...)

if type(arg[1]) ~= "table" then
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
