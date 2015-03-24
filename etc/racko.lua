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

local SAVEDIR = 'racko-data/'
local STALE_LIMIT = 1800 -- consider a game expired after x seconds

local install, load, save, initialize_state, fill_deck, count_players, msg_handler, is_sequence, is_racko

install = function()
  os.mkdir(SAVEDIR)
end

load = function(chan)
  local f = io.open(SAVEDIR..chan..".json")
  if not f then
    return false, "game state not found"
  end

  local data = f:read("*a")
  local state, err = json.decode(data)
  if not state then
    return false, "unable to deserialize: "..err
  end

  if os.time() - state.active_ts > STALE_LIMIT then
    return false, "game stale"
  end

  f:close()
  return state
end

save = function(chan, state)
  state.active_ts = os.time()
  local path = SAVEDIR..chan..".json"
end

initialize_state = function()
  local state = {}
  state.deck = {}
  state.deck_filled = false
  -- state.players[nick] = {rack = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}}
  state.players = {}
  state.deck_ = false
  state.ts = os.time()
  state.active_ts = os.time() -- last time the state was touched
  return state
end

-- fills the deck with the right amount of cards, shuffles it
fill_deck = function(state)
  assert(not state.deck_filled, "deck already filled")

  local player_count = count_players(state)
  
  local counts = {[2] = 40, [3] = 50, [4] = 60}
  assert(counts[player_count], "too few or too many players (expected 2-4)")
  
  for i=1, counts[player_count] do
    state.deck[i] = i
  end
  
  etc.shuffle(state.deck)

  state.deck_filled = true
end

count_players = function(state)
  local n = 0
  for _ in pairs(state.players) do
    n = n + 1
  end
  return n
end

is_sequence = function(rack)
  for i=1, #rack do
    if rack[1] + i - 1 ~= rack[i] then
      return false
    end
  end
  return true
end

is_racko = function(rack)
  for i=2, #rack do
    if rack[i - 1] > rack[i] then return false end
  end
  return true
end

-- Handles incoming game input
msg_handler = function(state, reply, player_name, line)
  line = line or ""

  local tokens = {}
  for token in line:gmatch("[^%s]+") do
    tokens[#tokens + 1] = token
  end

  local has_joined = state and state.players[player_name] ~= nil

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
    local ok, err = add_player(state, player_name)
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

    if is_racko(state.players[player_name]) then
      reply("Congratulations")
    else
      reply("Sorry, but you don't have a valid sequence")
    end
  end
end

install()

