-- Example simple / easy game
-- Control a dummy player via 'cmd dummy ... like 'cmd dummy join
-- Also use etc.parseCard(param) if you want to parse a card from a user.

if Editor then return end


gamename = "simplegame"


require 'game'
require 'game.cards'


-- Start the game; deal cards, setup game state, etc.
function game_start(game_control)
  game_control.dealCards(1)
end


-- Called when this player's turn has begun and we're about to wait for their input.
function game_wait_turn(game_control, player)
  local hand = assert(game_control.getPlayerHand(player.nick))
  if #hand == 0 then
    game_control.gameover()
  else
    game.print("It is " .. player.nick .. "'s turn, please type: " ..
      etc.cmdprefix .. gamename .. " play")
    game.expect("play")
  end
end


-- Function game_<foo> is called when the current player does 'cmd <foo>
function game_play(game_control, player, param)
  local hand = assert(game_control.getPlayerHand(player.nick))
  game.print(player.nick .. " plays a " .. tostring(hand[1]) .. " - Is this card the highest?")
  hand:remove(1)
  game_control.nextPlayer() -- Move to next player!
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Easy Game Description!'))
game.handleCmd(...)
