API "1.1"

local list
if type(arg[1]) == "string" then
  list = etc.getCardsFromIndex(...)
else
  list = etc.getCardsIndexed(...)
end

return util.listable(list, util.createCard, util.decomposeCard, "cards")



--[==[
-- NOT YET Usage: (list) or (numberOfDecks, wantJokers, ordered), all optional

if type(arg[1]) == "table" or type(arg[1]) == "string" then
  return util.listable(arg[1], util.createCard, util.decomposeCard, "cards")
end

local numberOfDecks = arg[1] or 1
local wantJokers = arg[2] or false
local ordered = (arg[3] ~= false)

local list = util.listable({}, util.createCard, util.decomposeCard, "cards")
for ideck = 1, numberOfDecks do
  for i = 1, 52 do
    list:add(util.createCard((ideck - 1) * 52 + i))
  end
  -- Jokers go negative starting at -1
  list:add(util.createCard((ideck - 1) * -2 - 1))
  list:add(util.createCard((ideck - 1) * -2 - 2))
end

if not ordered then
  -- Randomize...
end

return list
--]==]

