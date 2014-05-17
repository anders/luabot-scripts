local cards, err

if type(arg[1]) == "table" then
  -- Can pass in a deserialized table to get back normal cards.
  cards = arg[1]
  assert(#cards == 0 or type(cards[1]) == "table", "Expected a table of tables")
else
  -- Or just tell me how many decks you want, default 1. Also true if you want jokers.
  cards, err = _getCards(...)
end

local cardMT = {
  __tostring = _cardsString,
  __eq = function(a, b)
    -- print("Comparing " .. etc.t(a) .. " with " .. etc.t(b))
    if not a.suit or not b.suit then
      -- If decks:
      -- return a==b -- C stack overflow.
      assert(rawequal, "Cannot compare whole decks")
      return rawequal(a, b)
    end
    -- If cards:
    return a.value == b.value and a.suit == b.suit
  end
}

if cards then
  for i, v in ipairs(cards) do
    setmetatable(v, cardMT)
  end
  function cards:draw(n)
    if not n then
      return table.remove(self)
    end
    local t = {}
    for i = 1, n do
      local x = table.remove(self)
      if x then
        table.insert(t, x)
      end
    end
    setmetatable(t, getmetatable(self))
    return t
  end
  setmetatable(cards, cardMT)
  return cards
end

return cards, err
