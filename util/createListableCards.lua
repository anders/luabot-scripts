API "1.1"
-- Usage: (list) or (numberOfDecks, wantJokers, ordered), all optional

if type(arg[1]) == "table" or type(arg[1]) == "string" then
  return util.listable(arg[1], util.createCard, util.decomposeCard, "cards")
end

local numberOfDecks = arg[1] or 1
local wantJokers = arg[2] or false
local ordered = arg[3] or false

local list = util.listable({}, util.createCard, util.decomposeCard, "cards")
for ideck = 1, numberOfDecks do
  for i = 1, 52 do
    list:add(util.createCard((ideck - 1) * 54 + i))
  end
  if wantJokers then
    list:add(util.createCard((ideck - 1) * 54 + 53))
    list:add(util.createCard((ideck - 1) * 54 + 54))
  end
end

if not ordered then
  -- Randomize...
  for i = 1, #list do
    local n = math.floor(saferandom() * #list) + 1
    assert(n >= 1 and n <= #list)
    list[i], list[n] = list[n], list[i]
  end
end

return list


--[[ -- Old:
local list
if type(arg[1]) == "string" then
  list = etc.getCardsFromIndex(...)
else
  list = etc.getCardsIndexed(...)
end

return util.listable(list, util.createCard, util.decomposeCard, "cards")
--]]

