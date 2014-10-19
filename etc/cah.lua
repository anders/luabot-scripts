API "1.1"

if Editor then return end

local function loadcards(fn, t)
  t = t or {}
  local f = assert(io.open(fn))
  local data = f:read("*a")
  f:close()
  for x in (data:match("^cards=(.*)") or data):gmatch("[^<>]+") do
    t[#t + 1] = x
  end
  return t
end

local function listableCards(cards)
  return util.listable(cards,
    function(id)
      return { id = id, value = cards[id] }
    end,
    function(card)
      return card.id
    end,
    'cah_cards')
end

local function arrayToListItems(t)
  local result = {}
  for i = 1, #t do
    result[i] = { id = i, value = t[i] }
  end
  return result
end


local LOG = plugin.log(_funcname);

gamename = "cah"

require 'game'
require 'game.cards'

require "RandomLua"

-- game.minPlayers = 3

local czarTitle = "Card Czar"


local function randomize(array, randomseed)
  local rng = RandomLua.twister(randomseed)
  for i = 1, #array do
    local x = rng:random(#array)
    array[i], array[x] = array[x], array[i]
  end
  return array
end


local function initCards(game_control)
  local gamedata = game_control.getGameData()
  if not Private._wcards then
    Private._wcards = listableCards(arrayToListItems(loadcards("cah/wcards.txt")))
    randomize(Private._wcards, gamedata.wcardseed)
  end
  if not Private._bcards then
    Private._bcards = listableCards(arrayToListItems(loadcards("cah/bcards2.txt", loadcards("cah/bcards1.txt", loadcards("cah/bcards.txt")))))
    randomize(Private._bcards, gamedata.bcardseed)
  end
end

local function wcardNew(game_control)
  local gamedata = game_control.getGameData()
  local ncards = gamedata.nwcards or 0
  local c = Private._wcards[ncards + 1]
  gamedata.nwcards = ncards + 1
  return c
end

local function bcardNew(game_control)
  local gamedata = game_control.getGameData()
  local ncards = gamedata.nbcards or 0
  local c = Private._bcards[ncards + 1]
  gamedata.nbcards = ncards + 1
  return c
end


local function getCurrentBlackCards(game_control, wantBlank)
  -- List of one, to make serializing easier.
  local gamedata = game_control.getGameData()
  return Private._bcards:create(wantBlank and "" or gamedata.bcards)
end


local function getPlayerCards(game_control, who, wantBlank)
  local playerObj = game_control.getPlayerData(who)
  local pcards = Private._wcards:create(wantBlank and "" or playerObj.cards)
  pcards.onChange = function(self)
    playerObj.cards = pcards:serialize()
  end
  return pcards
end


local function formatCards(cards)
  local t = {}
  for i = 1, #cards do
    local c = cards[i]
    t[#t + 1] = "|"
    t[#t + 1] = tostring(i)
    t[#t + 1] = ") "
    t[#t + 1] = tostring(c.value)
  end
  t[#t + 1] = "|"
  return table.concat(t, "")
end


local function countBlanks(card)
  local n = 0
  for blank in card.value:gmatch("__+") do
    n = n + 1
  end
  return n
end


local function isPlayerCzar(game_control, who)
  local gamedata = game_control.getGameData()
  local iczar = gamedata.iczar
  local czar = game_control.getPlayerData(iczar)
  return game_control.getPlayerData(who).nick == czar.nick
end


local function getRoundFirstPlayerObj(game_control)
  LOG.debug("curr player is", game_control.getPlayerData(who).nick)
  local gamedata = game_control.getGameData()
  local iczar = gamedata.iczar
  local czar = game_control.getPlayerData(iczar)
  LOG.debug("czar player is", czar.nick)
  local firstplayer = iczar + 1
  if firstplayer > game.getPlayerCount() then
    firstplayer = 1
  end
  LOG.debug("first player is", game_control.getPlayerData(firstplayer).nick)
  return game_control.getPlayerData(firstplayer)
end


local function isRoundFirstPlayer(game_control, who)
  return game_control.getPlayerData(who).nick == getRoundFirstPlayerObj(game_control).nick
end


local function isRoundLastPlayer(game_control, who)
  LOG.debug("curr player is", game_control.getPlayerData(who).nick)
  local gamedata = game_control.getGameData()
  local iczar = gamedata.iczar
  local czar = game_control.getPlayerData(iczar)
  LOG.debug("czar player is", czar.nick)
  local lastplayer = iczar - 1
  if lastplayer == 0 then
    lastplayer = game.getPlayerCount()
  end
  LOG.debug("last player is", game_control.getPlayerData(lastplayer).nick)
  return game_control.getPlayerData(who).nick == game_control.getPlayerData(lastplayer).nick
end


-- Start the game; deal cards, setup game state, etc.
function game_start(game_control)
  local gamedata = game_control.getGameData()
  -- Initialize some reproducible random seeds.
  local crng = RandomLua.twister(seed or math.random(999999999))
  gamedata.wcardseed = crng:random(999999999)
  gamedata.bcardseed = crng:random(999999999)
  -- Deal the cards:
  initCards(game_control)
  for i = 1, game.getPlayerCount() do
    local pobj = game_control.getPlayerData(i)
    local pcards = getPlayerCards(game_control, pobj, true)
    pcards:freeze()
    for i = 1, 10 do
      local c = wcardNew(game_control)
      pcards:add(c)
    end
    pcards:unfreeze()
    game.sendNotice(pobj.nick, "Your white cards: " .. formatCards(pcards))
  end
end


function game_bots(game_control, playerCount, addBot)
  --[[
  if playerCount < 2 then
    addBot("Calvin")
  end
  --]]
end


-- Called when this player's turn has begun and we're about to wait for their input.
function game_wait_turn(game_control, player)
  initCards(game_control)
  local gamedata = game_control.getGameData()
  local iczar = gamedata.iczar
  if not iczar then
    LOG.debug("czar being set to " .. tostring(player))
    iczar = game_control.getPlayerData(player).index
    assert(type(iczar) == "number", "iczar not a number")
    gamedata.iczar = iczar
    game.print(tostring(player) .. " is the new " .. czarTitle)
    local bcards = getCurrentBlackCards(game_control, true)
    bcards:add(bcardNew(game_control))
    gamedata.bcard = bcards:serialize()
    game.print("Black card *** " .. bcards[1].value)
    return game_control.nextPlayer()
  elseif isPlayerCzar(game_control, player) then
    local bcards = getCurrentBlackCards(game_control)
    game.sendNotice(player, "All players have chosen their answers, please choose which cards fill in the blanks best for the phrase: *** " .. bcards[1].value)
    -- SEND POSSIBLE ANSWERS...... TODO
    game.print("It is now time for " .. czarTitle .. " " .. player .. " to deliberate and choose the winner! Please stand by, this may take some time to decide.")
    game.sendNotice(tostring(player), "Please type '" .. etc.cmdprefix .. gamename .. " choose <winning_number> (where <winning_number> is the number before one of your choices.")
    return game.expect("choose")
  else
    game.print("It is " .. tostring(player) .. "'s turn, type '" .. etc.cmdprefix .. gamename .. " play <card_number> (where <card_number> is the number before one of your white cards)")
    local pcards = getPlayerCards(game_control, player)
    game.sendNotice(tostring(player), "Your white cards: " .. formatCards(pcards))
  end
  game.expect("play")
end


function game_bot_turn(game_control, bot, botInput)
end


-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_play(game_control, player, param)
  initCards(game_control)
  local gamedata = game_control.getGameData()
  
  local bcards = getCurrentBlackCards(game_control)
  local needcards = countBlanks(bcards[1])
  
  local playerObj = game_control.getPlayerData(player)
  local pcards = getPlayerCards(game_control, player)
  
  local icard1, icard2 = param:match("^(%d+)[ ,;]*(%d*)")
  if not icard1 or (needcards > 1 and not icard2) then
    if needcards > 1 then
      game.sendNotice(tostring(player), "Please provide both white card numbers in the appropriate order, such as: 4, 2")
    else
      game.sendNotice(tostring(player), "Please provide the white card number")
    end
    return game_control.nextPlayer(player)
  end
  
  if icard1 < 1 or icard1 > #pcards then
    game.sendNotice(tostring(player), "Card " .. icard1 .. " is out of range")
    return game_control.nextPlayer(player)
  end
  if icard2 then
    if icard2 < 1 or icard2 > #pcards then
      game.sendNotice(player, "Card " .. icard2 .. " is out of range")
      return game_control.nextPlayer(player)
    end
    if icard1 == icard2 then
      game.sendNotice(player, "Both cards cannot be the same!")
      return game_control.nextPlayer(player)
    end
  end
  
  local cardsChosen = pcards:create()
  cardsChosen:add(pcards[icard1])
  cardsChosen:add(pcards[icard2])
  playerObj.chosen = cardsChosen:serialize()
  
  pcards:removeAt(icard1)
  if icards2 > icard1 then
    icard2 = icard2 - 1 -- It's now offset by the removal.
  end
  pcards:removeAt(icard2)
  
  return game_control.nextPlayer()
end


-- czar's winning choice
function game_choose(game_control, player, param)
  initCards(game_control)
  local gamedata = game_control.getGameData()
  
  local iwin = param:match("^(%d+)")
  if not iwin then
    game.sendNotcie(player, "Please provide the winning number")
    return game_control.nextPlayer(player)
  end
  
  -- Ensure valid number...
  error("I'm glad it worked, but the game stops here :<")
  
  gamedata.iczar = false -- Next player will become czar.
  return game_control.nextPlayer()
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Cowchaser, Anus of the Hipster'))
game.handleCmd(...)



return false, "Not implemented lol"
