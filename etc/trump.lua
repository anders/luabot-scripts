-- Usage: 'trump join / start / play - the idea is to play your card to beat the other players with the highest card, where the trump suit always beats the other suits. If you win the most rounds, you win! Ace high.

if Editor then return end

local LOG = plugin.log(_funcname);

gamename = "trump"


require 'game'
require 'game.cards'


-- Start the game; deal cards, setup game state, etc.
function game_start(game_control)
  game_control.dealCards(7)
  local deck = game_control.getDeck()
  local trumpcard = deck:remove(1)
  game.print("The Trump suit is: " .. trumpcard.suit .. " (" .. tostring(trumpcard) .. ")")
  game_control.getGameData().trump = trumpcard.suit
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("Donny")
  end
end


local function isRoundLastPlayer(game_control, who)
  local gamedata = game_control.getGameData()
  local prevwinner = gamedata.prevwinner
  if not prevwinner then
    -- If no previous winner yet, uses the builtin last player:
    return game.isLastPlayer(who)
  end
  -- The new last player is the player before the previous winner:
  local lastplayer = prevwinner - 1
  if lastplayer == 0 then
    lastplayer = game.getPlayerCount()
  end
  LOG.debug("curr player is", game_control.getPlayerData(who).nick)
  LOG.debug("last player is", game_control.getPlayerData(lastplayer).nick)
  return game_control.getPlayerData(who).nick == game_control.getPlayerData(lastplayer).nick
end


-- Card score heavily depends on what is trump.
-- DOES NOT consider if the card doesn't match the valid suit.
local function getCardScore(game_control, card)
  local gamedata = game_control.getGameData()
  local result = 1
  if card.ace then
    result = 14
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
  if card.suit == gamedata.trump then
    result = result * 100
    LOG.debug("card is trump")
  else
    LOG.debug("card is not trump, card=", card.suit, "trump=", gamedata.trump)
  end
  return result
end


local function getCardAbbrev(card)
  if card.ace then
     return 'A' .. card.suit:sub(1, 1)
  elseif card.face then
    return card.value:sub(1, 1) .. card.suit:sub(1, 1)
  else
    return card.value .. card.suit:sub(1, 1)
  end
end


function handHasAnySuit(hand, suit)
  for i = 1, #hand do
    if hand[i].suit == suit then
      return true
    end
  end
  return false
end


-- Called when this player's turn has begun and we're about to wait for their input.
function game_wait_turn(game_control, player)
  local gamedata = game_control.getGameData()
  local hand = assert(game_control.getPlayerHand(player.nick))
  
  local hand = assert(game_control.getPlayerHand(player.nick))
  if #hand == 0 or #game_control.getDeck() == 0 then
    local highwon = 0
    local highwonnick = "NOBODY"
    local finalmsg = ""
    for i = 1, game.getPlayerCount() do
      local p = game_control.getPlayerData(i)
      if (p.setswon or 0) > highwon then
        highwon = p.setswon
        highwonnick = p.nick
      end
      if finalmsg ~= "" then
        finalmsg = finalmsg .. ", "
      end
      finalmsg = finalmsg .. p.nick .. " won " .. (p.setswon or 0) .. " sets"
    end
    game.print(finalmsg)
    game_control.gameover(highwonnick)
    return
  end
  
  game.cards.sortCards(hand)
  
  local more = ""
  if not gamedata.curwinner then
    more = " - Please start the round off with a card of your choice."
  end
  local trump = gamedata.trump
  game.print("It is " .. player.nick .. "'s turn, please type: " ..
    etc.cmdprefix .. gamename .. " play <card>    (trump suit is " .. trump .. ")")
  game.sendNotice(player.nick, "Your cards are: " .. tostring(hand) .. more)
  game.expect("play")
end


function game_bot_turn(game_control, bot, botInput)
  local gamedata = game_control.getGameData()
  local hand = assert(game_control.getPlayerHand(bot.nick))
  
  if #hand == 0 then
    LOG.error("bot's hand is empty")
    game_control.abandonGame()
    return
  end
  
  local curwincardvalue = gamedata.curwincard
  local curwincard
  if curwincardvalue then
    curwincard = etc.parseCard(curwincardvalue)
  end
  
  local playindex
  local xchosen = 0
  for i = 1, #hand do
    if not curwincard
        or hand[i].suit == gamedata.trump
        or hand[i].suit == curwincard.suit
        then
      xchosen = xchosen + 1
      if 1 == math.random(xchosen) then
        playindex = i
      end
    end
  end
  
  if not playindex then
    playindex = math.random(#hand)
  end
  local playcard = hand[playindex].value .. hand[playindex].suit
  
  botInput("play " .. playcard)
end


-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_play(game_control, player, param)
  local gamedata = game_control.getGameData()
  
  local card = assert(etc.parseCard(param or ''))
  local hand = assert(game_control.getPlayerHand(player.nick))
  local hascard = false
  for i = 1, #hand do
    if hand[i].value == card.value and hand[i].suit == card.suit then
      hascard = true
      break
    end
  end
  if not hascard then
    game.print("Can't play that!")
    game.sendNotice(player.nick, "You don't have that card")
    game_control.nextPlayer(player.nick) -- same player
    return
  end
  
  local curwincardvalue = gamedata.curwincard
  local curwincard
  if curwincardvalue then
    curwincard = etc.parseCard(curwincardvalue)
  end
  
  local curwinscore = gamedata.curwinscore or 0
  
  if curwincard
      and card.suit ~= curwincard.suit
      and card.suit ~= gamedata.trump
      and handHasAnySuit(hand, curwincard.suit)
      then
    game.print("Can't play that!")
    game.sendNotice(player.nick, "You need to play either the current suit or the trump suit")
    game_control.nextPlayer(player.nick) -- same player
    return
  end
  
  local curscore = 1
  if not curwincard or card.suit == curwincard.suit or card.suit == gamedata.trump then
    curscore = getCardScore(game_control, card)
    LOG.debug("curscore is", curscore)
  else
    LOG.debug("Not getting curscore")
  end
  
  hand:discard(card)
  
  local msg
  if curscore > curwinscore then
    gamedata.curwinner = player.index
    gamedata.curwinscore = curscore
    gamedata.curwincard = getCardAbbrev(card)
    msg = "The high card is now " .. tostring(card)
  else
    msg = "The high card is still " .. tostring(curwincard)
  end
  
  if isRoundLastPlayer(game_control, player) then
    local curwinner = game_control.getPlayerData(gamedata.curwinner)
    local curwincard = etc.parseCard(gamedata.curwincard)
    curwinner.setswon = (curwinner.setswon or 0) + 1
    game.print(curwinner.nick, "won the set with", tostring(curwincard))
    gamedata.curwinner = nil
    gamedata.curwinscore = 0
    gamedata.curwincard = nil
    gamedata.prevwinner = assert(curwinner.index, "curwinner.index")
    LOG.debug("Round over")
    game_control.nextPlayer(curwinner.nick) -- Move to the winner!
    return
  end
  
  game.print(msg)
  LOG.debug("Round continues")
  
  game_control.nextPlayer() -- Move to next player!
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Trump'))
game.handleCmd(...)


