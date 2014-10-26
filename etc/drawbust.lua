API "1.1"

-- NOT FINISHED YET!

if Editor then return end

local LOG = plugin.log(_funcname);
LOG.setPrintLevel(LOG.Level.ERROR);

gamename = "drawbust"

require 'game'
require 'game.cards'

local function playerDone(game_control, player)
end

local loser = {
  desc = "(2-4) your turn is over and you lose all (non-jacked) action cards.",
  doAction = function(game_control, player)
    playerDone(game_control, player)
    game_control.nextPlayer()
  end,
}

local lookup = {
  ["2"] = loser,
  ["3"] = loser,
  ["4"] = loser,
  ["5"] = {
    desc = "Does nothing on its own. If you own two 5's, you cannot have a king stolen.",
    doAction = function(game_control, player)
    end,
  },
  ["6"] = {
    desc = "Your turn is over but you don't lose, unless you have a 7 action card.",
    doAction = function(game_control, player)
    end,
  },
  ["7"] = {
    desc = "A 6 will not end your turn. even if you draw multiple 6's.",
    more = "When you have both 6 and 7 actions, when your turn is over, you can take the amount of cards you won from the top of the discard pile. this only works max once per turn. If not enough cards in the discard pile, then only take what is available.",
    doAction = function(game_control, player)
    end,
  },
  ["8"] = {
    desc = "Discard action cards except this one and resume playing, stopping at jacks.",
    doAction = function(game_control, player)
    end,
  },
  ["9"] = {
    desc = "You must play an additional 3 cards, unless an action ends the game.",
    doAction = function(game_control, player)
    end,
  },
  ["10"] = {
    desc = "You must discard your highest owned card immediately. Lowest to highest: 2-10, Jack, Queen, King, Ace.",
    doAction = function(game_control, player)
    end,
  },
  Jack = {
    desc = "Freeze your action cards from before this point. Even when you lose you keep all action cards from before it.",
    points = 10,
    doAction = function(game_control, player)
    end,
  },
  Queen = {
    desc = "Steal an owned king from another player immediately, and in exchange you discard your lowest owned card immediately.",
    more = "You must steal it from the player with the most kings. Random breaks ties. A king is protected if a user has two 5's. If nobody else has a king or they are all protected, nothing happens. If you don't have a lowest owned card (zero cards) you can take the king free of charge.",
    points = 10,
    doAction = function(game_control, player)
    end,
  },
  King = {
    desc = "Make all other players discard their lowest owned card immediately.",
    points = 10,
    doAction = function(game_control, player)
    end,
  },
  Ace = {
    desc = "Peek at the next card and decide if you want to draw it or not.",
    points = 11,
    doAction = function(game_control, player)
    end,
  },
}

local function getCardPoints(card)
  local x = lookup[card.value or "?"]
  if x and x.points then
    return x.points
  end
  if card.number then
    return card.number
  end
  LOG.error("Unknown card points: " .. tostring(card))
  return 0
end

function game_start(game_control)
  game_control.dealCards(0)
  -- local deck = game_control.getDeck()
end


local function getPlayerScore(player)
  local hand = assert(game_control.getPlayerHand(player.nick))
  local score = 0
  for i = 1, #hand do
    score = score + getCardPoints(hand[i])
  end
  return score
end


local function findWinners(game_control)
  local highestScore = -1
  local highestPlayers = "U"
  for i = 1, game.getPlayerCount() do
    local player = game_control.getPlayerData(i)
    local score = getPlayerScore(player)
    if score >= highestScore then
      if score == highestScore then
        highestPlayers = highestPlayers .. ", " .. player.nick
      else
        highestScore = score
        highestPlayers = player.nick
      end
    end
  end
  return "U"
end


-- Called when this player's turn has begun and we're about to wait for their input.
function game_wait_turn(game_control, player)
  do
    local deck = game_control.getDeck()
    if #deck == 0 then
      game.print("All cards drawn!")
      local winners = findWinners(game_control)
      game_control.gameover(winners)
      return
    end
  end
  
  local gamedata = game_control.getGameData()
  -- local hand = assert(game_control.getPlayerHand(player.nick))
  
  game.print(player.nick .. "'s turn, type draw or done. "
    .. etc.cmdprefix .. gamename .. " draw")
end

-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_draw(game_control, player, param)
  local gamedata = game_control.getGameData()
  
  local hand = assert(game_control.getPlayerHand(player.nick))
  local card = hand:addFromDeck() -- WRONG: it's not his card yet!!!
  local info = lookup[card.value]
  assert(info, "Couldn't lookup card " .. tostring(card))
  
  game.print("Draw: " .. tostring(card) .. " - " .. tostring(lookup.desc)
    .. (lookup.more and " [more...]" or "")
    .. " (" .. getCardPoints(card) .. " points)"
    )
  
  info.doAction(game_control, player)
  
end

-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_done(game_control, player, param)
  local gamedata = game_control.getGameData()
  
  game.print(player.nick .. " plays it safe and keeps their winnings")
  playerDone(game_control, player)
  game_control.nextPlayer()
end

-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Draw-Bust'))
game.handleCmd(...)
