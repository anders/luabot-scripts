-- Usage: require'game'; require'game.cards';

local M = {}
local game = require 'game';
game.cards = M


local function getCardsHelper(root, name)
  local h = etc.getCardsFromIndex(root[name])
  local hobj = h
  --- Deck/hand of cards object.
  function hobj:add(card)
    assert(type(root) == "table" and type(name) == "string", "invalid types root,name=" .. type(root)..","..type(name))
    assert(self == hobj, "Invalid self")
    assert(type(card) == "table" and card.value and card.suit)
    h[#h + 1] = card
    root[name] = etc.getCardsToIndex(h)
  end
  --- Find a card in this deck/hand by index or card object.
  function hobj:find(card)
    assert(self == hobj, "Invalid self")
    if type(card) == "number" then
      return card
    end
    for i, v in ipairs(h) do
      if v.value == card.value and v.suit == card.suit then
        return i
      end
    end
    return false
  end
  --- Find and remove a card.
  function hobj:remove(card)
    assert(self == hobj, "Invalid self")
    local i = self:find(card)
    if i then
      local c = h[i]
      table.remove(h, i)
      root[name] = etc.getCardsToIndex(h)
      return c
    end
    return nil
  end
  --- testfunc called for each card, card removed if function returns true.
  function hobj:removeif(testfunc)
    assert(self == hobj, "Invalid self")
    local i = 1
    while h[i] do
      repeat
        if testfunc(h[i]) then
          self:remove(i)
          break
        end
        i = i + 1
      until true
    end
  end
  --- Find and move card into discard pile.
  function hobj:discard(card)
    local c = self:remove(card)
    local discards = Private.game_control.getDiscardPile()
    discards:add(assert(c, "What card?"))
  end
  -- Add a card to this hand from the deck.
  function hobj:addFromDeck()
    assert(self == hobj, "Invalid self")
    local deck = Private.game_control.getDeck()
    if #deck == 0 then
      -- Automatically shuffle up the discards and reuse them.
      game.print("Shuffling up the discard pile and reusing cards")
      local discards = Private.game_control.getDiscardPile()
      for i = 1, #discards do
        local ri = math.random(#discards)
        discards[i], discards[ri] = discards[ri], discards[i]
      end
      for i = 1, #discards do
        deck:add(discards[i])
      end
      Private.game_data.discard = ""
      if #deck == 0 then
        game.print("OUT OF CARDS - DECK IS EMPTY!")
        return h[#h] -- Just pretend we got the last card again.
      end
    end
    local c = deck:remove(#deck)
    h:add(c)
    return c
  end
  return hobj
end


--- General create deck function but doesn't give cards to the players.
--- Defaults: how_many_decks = 1, want_jokers = false.
function Private.game_control.createDeck(how_many_decks, want_jokers)
  assert(not Private.game_data.deck, "Cannot create deck a second time")
  local deck = etc.getCardsIndexed(tonumber(how_many_decks) or 1, want_jokers)
  Private.game_data.deck = etc.getCardsToIndex(deck)
  Private.game_data.discard = ""
  return deck
end


--- Create deck and deal initial cards to all players.
function Private.game_control.dealCards(how_many_each_player, how_many_decks, want_jokers)
  local deck = Private.game_control.createDeck(how_many_decks, want_jokers)
  for i = 1, #Private.game_data.players do
    Private.game_data.players[i].hand = etc.getCardsToIndex(deck:draw(how_many_each_player))
  end
  Private.game_data.deck = etc.getCardsToIndex(deck)
  Private.game_data.discard = ""
end


--- Get the deck cards-object.
function Private.game_control.getDeck()
  if Private.game_data.deck then
    return getCardsHelper(Private.game_data, 'deck');
  end
  return false, "No deck"
end


--- Get the discard pile cards-object.
function Private.game_control.getDiscardPile()
  if Private.game_data.deck then
    return getCardsHelper(Private.game_data, 'discard');
  end
  return false, "No deck"
end


--- Get a player's hand cards-object.
function Private.game_control.getPlayerHand(who)
  who = who or nick
  local p = assert(Private.game_control.getPlayerData(who), 'No such player ' .. who)
  return getCardsHelper(p, 'hand')
end


--- Returns the numeric value of the card, or higher for face and ace.
--- aceHigh is true by default, set to false if ace is lower than 2.
function M.getCardRank(card, aceHigh)
  local result = 0
  if aceHigh == nil then
    aceHigh = true
  end
  if card.ace then
    result = 1
    if aceHigh then
      result = 14
    end
  elseif card.face then
    if card.value == "King" then
      result = 13
    elseif card.value == "Queen" then
      result = 12
    elseif card.value == "Jack" then
      result = 11
    end
  elseif card.number then
    result = card.number
  end
  return result
end


--- Sorts the provided cards, in-place.
--- By default sorts by suit, but if numeric is true sorts by number first.
--- Note: be careful if sorted cards could leak information about a player's private cards.
function M.sortCards(cards, numeric)
  local rank = M.getCardRank
  if numeric then
    table.sort(cards, function(a, b)
      return rank(a) < rank(b)
    end)
  else
    table.sort(cards, function(a, b)
      if a.suit < b.suit then
        return true
      end
      if a.suit == b.suit then
        return rank(a) < rank(b)
      end
      return false
    end)
  end
  return cards
end


return M
