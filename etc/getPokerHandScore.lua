local cards = arg[1]
assert(type(cards) == "table", "Expected table of cards")

if #cards == 5 then
  local x, y = _getPokerHandScore(cards)
  return x, y
elseif #cards > 5 then
  local x, y = 0, "?"
  local xcards = {}
  local ncards = #cards
  for a = 1, ncards do
        for b = a + 1, ncards do
            for c = b + 1, ncards do
                for d = c + 1, ncards do
                    for e = d + 1, ncards do
                        xcards[1] = cards[a]
                        xcards[2] = cards[b]
                        xcards[3] = cards[c]
                        xcards[4] = cards[d]
                        xcards[5] = cards[e]
                        local x2, y2 = _getPokerHandScore(xcards)
                        if x2 > x then
                          x = x2
                          y = y2
                        end
                    end
                end
            end
        end
    end
    return x, y
else
  error("Invalid number of poker cards: " .. #cards)
end
