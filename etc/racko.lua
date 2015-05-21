API "1.1"

local json = require "json"

--[[
Rack-O

gameplay:

2-4 players

deck:
      2 players: 1-40,
      3 players: 1-50,
      4 players: 1-60

each player has a rack of 10 cards

dealer shuffles and deals 10 cards to each player

player must put each received card in the highest available slot (#10)

goal is to have a sequence of numbers, low to high, starting at slot #1

top card of deck is turned, becomes the discard pile

a turn is taken by taking the top card from the deck, or the discard pile
and replacing one of the cards in the rack. if the card was taken from the deck, it may be
discarded. if it was taken from the discard pile, it must be put in the rack.

first player to get an ascending sequence of 10 cards wins
]]

local function is_sequence(rack)
  for i=1, #rack do
    if rack[1] + i - 1 ~= rack[i] then
      return false
    end
  end
  return true
end

local function is_racko(rack)
  for i=2, #rack do
    if rack[i - 1] > rack[i] then return false end
  end
  return true
end

local function msg_handler(state, reply, name, id, line)
  line = line or ""

  local tokens = {}
  for token in line:gmatch("[^%s]+") do
    tokens[#tokens + 1] = token
  end

  local has_joined = state and state.players[id] ~= nil

  if tokens[1] == "" or tokens[1] == "new" then
    if state then
      if state.started then
        reply("There is already an active game.")
      else
        -- should maybe assume the player wants to join
        reply("A game is about to start, use 'racko join to play.")
      end

      return
    end

  elseif tokens[1] == "join" then
    local ok, err = add_player(state, id)
    if not ok then
      reply("Sorry: "..err)
      return
    end

    local n = count_players(state)
    if n >= 2 and n <= 4 then
      reply("You have joined the game. There are enough players to play, you can use 'racko start")
    else
      reply("You have joined the game, need at least one more player to start.")
    end

  elseif tokens[1] == "racko" then
    if not has_joined then
      reply("You haven't joined the game")
      return
    end

    if is_racko(state.players[id]) then
      reply("Congratulations")
    else
      reply("Sorry, but you don't have a valid sequence")
    end

  elseif tokens[1] == "test" then
    reply("testing the reply func")
  end
end

local function make_reply_func(nick)
  return function(msg)
    print(nick..": "..msg)
  end
end

if not account or account < 1 or account > 1000000 then
  print(nick.." * you need to be authenticated to play.")
  return
end

-- 3rd arg should be the user id
msg_handler(state, make_reply_func(nick), nick, account, arg[1])
