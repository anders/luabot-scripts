API "1.1"

if Editor then return end

local function loadcards(fn, t)
  t = t or {}
  local data = assert(io.open(fn)):read("*a")
  for x in (data:match("^cards=(.*)") or data):gmatch("[^<>]+") do
    t[#t + 1] = x
  end
  return t
end

local function listableCards(cards)
  return util.listable(cards,
    function(id)
      return { cards[id], id = id }
    end,
    function(card)
      return card.id
    end,
    'cah_cards')
end

local function arrayToCards(t)
  local result = {}
  for i = 1, #t do
    result[i] = { id = i, card = t[i] }
  end
  return result
end

local LOG = plugin.log(_funcname);

gamename = "cah"


require 'game'
require 'game.cards'


-- Start the game; deal cards, setup game state, etc.
function game_start(game_control)
  game_control.getGameData().stuff = 42
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("Calvin")
  end
end


local function isRoundLastPlayer(game_control, who)
  local lastplayer = game.getPlayerCount()
  return game_control.getPlayerData(who).nick == game_control.getPlayerData(lastplayer).nick
end


-- Called when this player's turn has begun and we're about to wait for their input.
function game_wait_turn(game_control, player)
  
  game.expect("play")
end


function game_bot_turn(game_control, bot, botInput)
  
end


-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_play(game_control, player, param)
  
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Cowchaser, Anus of the Hipster'))
game.handleCmd(...)



return false, "Not implemented lol"
