API "1.1"
-- Usage: simple game. Players join and then the game will start. Each player starts with 100 points. Per round each player puts in a fake amount and a real amount of points they spend on the round. Other players can call you out if the fake points are not equal to real points bet, otherwise they are suckers and you get away with free points. Person with the most points at the end wins. If someone tries to call you out and you were not suckering them, they also lose points equal to your bet.

if Editor then return end

local LOG = plugin.log(_funcname);


require 'game'
require 'game.cards'


function game_start(game_control)
  game_control.dealCards(7)
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("Loach")
  end
end


function game_wait_turn(game_control, player)
  game.print("It is " .. player.nick .. "'s turn, please type: " .. etc.cmdprefix .. _funcname .. "bet <mode> <value> (where mode is A or B and bet is C D E or F, such as: " .. etc.cmdprefix .. _funcname .. " bet A C)")
  if not warnletter then
    warnletter = true
    game.print("Please remember that the letters are randomized each time! so that other players can't figure out what you're doing.")
  end
  game.sendNotice(player.nick, "") -- ... 
  game.expect("bet")
end


function game_bot_turn(game_control, bot, botInput)
  -- ...
  botInput("bet A C")
end


function game_bet(game_control, player, param)
  local mode, bet = param:match("^(%a) *(%a)$")
  if not bet then
    game.print("I don't know what that means, can you please try again")
    game_wait_turn(game_control, player)
    return
  end
  local playerdata = game_control.getPlayerData(takefromnick)
  -- ...
  if game.isLastPlayer(player) then
    -- Check who wins...
    -- Don't announce anything unless called out.
    -- game.gameover(winner)
  end
  game_control.nextPlayer()
end

print("NOT IMPLEMENTED ******")

assert(game.init(_G, 'sucker', 'Sucker!'))
game.handleCmd(...)
