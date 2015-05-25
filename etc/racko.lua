API "1.1"

if not chan then return end

local json = require "json"

-- local Log = plugin.log("Rack-O")

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

--[[

<anders> 'racko join
<luabot> anders: You have joined the game, need one more player
<fooooo> 'racko join
<luabot> anders: You have joined the game, ready to begin
<anders> 'racko start
-luabot- [Rack-O!] Your rack: a1, b2, c3, d4, e5, f6, g7, h8, i9, j10
<luabot> anders: It's your turn. Use "replace <letter>" to accept the drawn card, "discard" to discard.
-luabot- [Rack-O!] Drawn card: 7. Top of discard: 9.
<anders> discard
or..
<anders> replace b
-luabot- [Rack-O!] Your rack: a1, b7, c3, d4, e5, f6, g7, h8, i9, j10
<luabot> fooooo: It's your turn. . . .


]]

local SAVE_DIR = "racko"
local STALE_TIME = 3600
local MIN_PLAYERS = 2
local MAX_PLAYERS = 4

local function load_game()
  local state

  os.mkdir(SAVE_DIR)

  local game_path = SAVE_DIR.."/"..chan..".dat"
  local f = io.open(game_path, "r")
  local data
  if f then
    data = f:read("*a")
    f:close()
    state = json.decode(data)
  end
  
  if not state or (state.last_activity and os.time() - state.last_activity > STALE_TIME) then
    return {
      players = {},
      order = {},
      turn = 1 -- state.order[state.turn] -> player id
    }
  else
    return state
  end
end

local function save_game(state)
  -- only save if requested
  if state.dirty then
    state.last_activity = os.time()
    state.dirty = nil
    local game_path = SAVE_DIR.."/"..chan..".dat"
    local f = io.open(game_path..".tmp", "w")
    local serialized = json.encode(state)
    assert(#serialized > 0, "json serialized = empty")
    f:write(serialized)
    f:close()
    os.remove(game_path)
    os.rename(game_path..".tmp", game_path)
  end
end

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

local function count_players(state)
  local n = 0
  for k, v in pairs(state.players) do n = n + 1 end
  return n
end

local function add_player(state, id, name)
  if state.started then
    return false, "Cannot add players to an active game."
  end

  if state.players[id] then
    return false, "You are already in the game."
  end

  if count_players(state) >= MAX_PLAYERS then
    return false, "Maximum number of players is "..MAX_PLAYERS.."."
  end
  
  state.players[id] = {rack = {}, name = name}
  state.order[#state.order + 1] = id
  state.dirty = true
  
  return count_players(state)
end

local function rack_string(rack)
  local tmp = {}
  for i, v in ipairs(rack) do
    -- Example: a5 b3 c9 d40 e10 . . .
    tmp[#tmp + 1] = ("%s%d"):format(string.char(96 + i), v)
  end
  return table.concat(tmp, ", ")
end

local function start_game(state)
  state.deck = {}
  state.discard = {}
  
  for i=1, (2 + count_players(state)) * 10 do state.deck[i] = i end
  etc.shuffle(state.deck) -- TODO: pass better random func as 2nd arg
  
  -- deal cards to players
  for k, id in ipairs(state.order) do
    local rack = state.players[id].rack or {}
    -- technically, this is dealing each player 10 cards at a time. but i don't think
    -- it makes any difference, it shouldn't
    for i=1, 10 do
      rack[#rack + 1] = table.remove(state.deck)
    end
    state.players[id].rack = rack
  end
  
  -- top card forms the discard pile
  state.discard[1] = table.remove(state.deck)
  
  state.dirty = true
end

local function msg_handler(state, reply, name, id, line)
  line = line or ""
  id = tostring(assert(id)) -- json module borks if it's a number

  local tokens = {}
  for token in line:gmatch("[^%s]+") do
    tokens[#tokens + 1] = token
  end
  
  if state.players[id] then
    -- In case the player changed their name
    state.players[id].name = name
  end

  if tokens[1] == "" or tokens[1] == "racko" then
    -- player not in game? assume join instead
    if not state.players[id] then
      return msg_handler(state, reply, name, id, "join")
    end
    
    -- deal with shouting Rack-O!
    
    if is_racko(state.players[id]) then
      reply("Congratulations! You won the game :-)")
    else
      reply("Sorry, but you don't have a valid sequence. Numbers must be ascending.")
    end

  elseif tokens[1] == "join" then
    local player_count, err = add_player(state, id, name)
    if not player_count then
      reply("Sorry: "..err)
      return
    end

    if player_count >= MIN_PLAYERS then
      reply("You have joined the game. There are enough players to begin, you can use 'racko start")
    else
      reply("You have joined the game, need at least one more player to start.")
    end
  
  elseif tokens[1] == "start" then
    local player_count = count_players(state)
    if not (player_count >= MIN_PLAYERS and player_count <= MAX_PLAYERS) then
      reply("Need at least "..MIN_PLAYERS.." to play Rack-O.")
      return
    end
    
    start_game(state)
    
    -- just to see how the rack would look
    reply(rack_string(state.players[id].rack), true)


  elseif tokens[1] == "guest" then
    return msg_handler(state, function(s) reply("(guest) "..s) end, "$guest", 28292717, line:match("guest%s+(.+)"))
  
  elseif tokens[1] == "reset" then
    os.remove("racko/"..chan..".dat")
    reply("*poof*")
  end
end

local function make_reply_func(nick)
  return function(msg, private)
    if not private then
      print(nick..": "..msg)
    else
      sendNotice(nick, "[Rack-O] "..msg)
    end
  end
end

local reply = make_reply_func(nick)

-- 28292717 = $guest
if not account or account < 1 or account >= 28292717 then
  reply("you need to be authenticated to play.")
  return
end

local state = load_game()

msg_handler(state, reply, nick, account, arg[1])

save_game(state)
