-- http://www.pagat.com/quartet/gofish.html

if Editor then return end

local LOG = plugin.log(_funcname);


--[[if arg[2] == "-reenter" then
  print("DEBUG fish reenter:", ...)
end--]]


require 'game'
require 'game.cards'


function game_start(game_control)
  game_control.dealCards(7)
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("Sharker")
  end
end


local function sorthand(hand)
  table.sort(hand, function(a, b)
    if a.value < b.value then
      return true
    end
    if a.value == b.value then
      return a.suit < b.suit
    end
    return false
  end)
end


-- Expects the hand to be sorted.
local function checkbooks(game_control, player, hand)
  if #hand == 0 or #game_control.getDeck() == 0 then
    -- Guy with most books is the winner.
    -- It's possible not to be the winner even if you ran out of cards,
    -- such as if someone keeps stealing 2+ of your cards at a time.
    local highbooks = 0
    local highbooksnick = "NOBODY"
    for i = 1, game.getPlayerCount() do
      local p = game_control.getPlayerData(i)
      if (p.nbooks or 0) > highbooks then
        highbooks = p.nbooks
        highbooksnick = p.nick
      end
    end
    game_control.gameover(highbooksnick, "LOL")
    return
  end
  local prevvalue = ""
  local prevsuit = ""
  for i = 1, #hand do
    if hand[i].value == prevvalue then
      nrep = nrep + 1
      if nrep == 4 then
        -- Found a book, so let's remove them, keep track, and check again.
        local handvalue = hand[i].value
        hand:removeif(function(c)
          return c.value == prevvalue
        end)
        -- The winning cards are gone now.
        player.nbooks = (player.nbooks or 0) + 1
        game.print(player.nick .. " now has a COMPLETE BOOK of " .. handvalue .. "s!"
          .. " (" .. player.nbooks .. " books)")
        checkbooks(game_control, player, hand)
        return true
      end
    else
      prevvalue = hand[i].value
      prevsuit = hand[i].suit
      nrep = 1
    end
  end
  return false
end


function game_wait_turn(game_control, player)
  game.print("It is " .. player.nick .. "'s turn, please type: " .. etc.cmdprefix .. "fish any <card> <nick> (such as: " .. etc.cmdprefix .. "fish any 4s freck)")
  local hand = assert(game_control.getPlayerHand(player.nick))
  sorthand(hand)
  assert(game_control, "no game_control")
  assert(player, "no player")
  assert(hand, "no hand")
  checkbooks(game_control, player, hand)
  game.sendNotice(player.nick, "Your fish cards are: " .. tostring(hand))
  game.expect("any")
end


function game_bot_turn(game_control, bot, botInput)
  local hand = assert(game_control.getPlayerHand(bot.nick))
  local wantcard
  if #hand < 1 or saferandom() < 0.10 then
    wantcard = math.random(2, 10)
  else
    wantcard = hand[math.random(#hand)].value
  end
  botInput("any " .. wantcard .. "s")
end


function game_any(game_control, player, param)
  local cardvalue, takefromnick = param:match("^([^ ]+) ?([^ ]*)$")
  if not cardvalue then
    game.print("I don't know what that means, can you please try again")
    game_wait_turn(game_control, player)
    return
  end
  local card = etc.parseCard(cardvalue:gsub("'", "") .. "h")
  if not card then
    game.print("That doesn't look like a card value...")
    game_wait_turn(game_control, player)
    return
  end
  local hand = assert(game_control.getPlayerHand(player.nick))
  --[[
  local hascard = false
  for i = 1, #hand do
    if hand[i].value == card.value then
      hascard = true
      break
    end
  end
  if not hascard then
    game.sendNotice(player.nick, "You don't have any " .. card.value .. "s but we'll try to find some anyway...")
  end
  --]]
  if takefromnick == "" then
    -- If only 2 players and they didn't specify who, just assume the other player.
    if game.getPlayerCount() == 2 then
      for i = 1, game.getPlayerCount() do
        local p = game_control.getPlayerData(i)
        if p.nick:lower() ~= player.nick:lower() then
          takefromnick = p.nick
        end
      end
      assert(takefromnick and takefromnick ~= "", "Unable to find other player")
    else
      game.print("Please indicate who you are asking")
      game_wait_turn(game_control, player)
      return
    end
  end
  local otherplayer = game_control.getPlayerData(takefromnick)
  if not otherplayer then
    game.print(takefromnick .. " doesn't appear to be in the game...")
    game_wait_turn(game_control, player)
    return
  end
  local otherhand = assert(game_control.getPlayerHand(otherplayer.nick))
  local tookn = 0
  otherhand:removeif(function(othercard)
    if othercard.value == card.value then
      tookn = tookn + 1
      hand:add(othercard)
      return true
    end
  end)
  if tookn > 0 then
    game.print(player.nick .. " took " .. tookn .. " " .. card.value .. "s from " .. otherplayer.nick)
    -- Same player:
    game_control.nextPlayer(player.nick)
  else
    hand:addFromDeck()
    game.print(otherplayer.nick .. " says GO FISH! and makes " .. player.nick .. " draw a card")
    game_control.nextPlayer(otherplayer.nick)
  end
end


assert(game.init(_G, 'fish', 'Go Fish'))
game.handleCmd(...)

