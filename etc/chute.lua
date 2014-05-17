-- Usage: just keep calling 'chute and then stuff happens. First to hit 100 wins.

if Editor then return end

local LOG = plugin.log(_funcname);

gamename = "chute"

require 'game'
require 'game.board'


local board = {}
board.__index = {}

function board.__index.spotText(spot)
  local s = '' .. spot.index
  if spot.move then
    s = s .. ', '
    if spot.move > spot.index then
      s = s .. 'up the bladder'
    else
      s = s .. 'down the chute'
    end
    s = s .. ' to ' .. spot.move
  end
  return s
end

for i = 1, 100 do
  board[i] = setmetatable({ index = i }, board)
end
board[1].move=38
board[4].move=14
board[9].move=31
board[16].move=6
board[28].move=84
board[21].move=42
board[36].move=44
board[47].move=26
board[49].move=11
board[51].move=67
board[56].move=53
board[64].move=60
board[62].move=19
board[71].move=91
board[80].move=100
board[87].move=24
board[93].move=73
board[95].move=75
board[98].move=78


function game_load(game_control, str)
  game_control.setBoard(board)
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("child")
  end
end


function game_wait_turn(game_control, player)
  game.print("It is " .. player.nick .. "'s turn, please type: " .. etc.cmdprefix .. "chute roll")
  game.expect("roll")
end


function game_bot_turn(game_control, bot, botInput)
  botInput("roll") -- game_roll / 'chute roll
end


-- Called when you just type 'chute,
function game_roll(game_control, player, param)
  local dice = game_control.rollDice()
  game.print(player.nick, "rolled:", tostring(dice))
  game_control.boardAdvancePlayer(player.nick, dice)
end


function board_game_moving_spot(game_control, player, spot, new_position)
  assert(new_position, "board_game_moving_spot: bad new_position")
  local old_position = game.board.getPlayerPosition(player.nick)
  assert(old_position, "board_game_moving_spot: bad old_position")
  if new_position < old_position then
    -- Don't wrap past the end.
    return #board
  end
end


function board_game_land_spot(game_control, player, spot, position)
  assert(position, "board_game_land_spot: bad position")
  assert(spot, "board_game_land_spot: bad spot")
  LOG.info("Moving to", position)
  -- LOG.trace(game.board.getSpotDisplayText(spot))
  if position == #board then
    game_control.gameover(player.nick)
  else
    game.print(player.nick, "*", game.board.getSpotDisplayText(spot))
    if spot.move then
      game_control.boardSetPlayerPosition(player.nick, spot.move)
    else
      game_control.nextPlayer()
    end
  end
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'Chutes and Bladders'))
game.handleCmd(...)



--[===[ -- Old code which works perfectly well.

local moves = {
  [1]=38,
  [4]=14,
  [9]=31,
  [16]=6,
  [28]=84,
  [21]=42,
  [36]=44,
  [47]=26,
  [49]=11,
  [51]=67,
  [56]=53,
  [64]=60,
  [62]=19,
  [71]=91,
  [80]=100,
  [87]=24,
  [93]=73,
  [95]=75,
  [98]=78,
}

local csv = require "csv"

local function moveEel(pos)
  for k, v in pairs(moves) do
    if k == pos then
      return v
    end
  end
  return pos
end

if Cache.chuteState == 'play' then
  local pi = Cache.chutePi or 1 -- player index
  -- print("pi=", pi, "player=", csv.get(Cache.chutePlayers, pi), "chutePlayers=", Cache.chutePlayers)
  local curplayer = csv.get(Cache.chutePlayers, pi)
  assert(curplayer, "curplayer=" .. tostring(curplayer) .. "???")
  Cache.chutePi = pi + 1
  if Cache.chutePi > csv.getLength(Cache.chutePlayers) then
    Cache.chutePi = 1
  end
  local roll = math.random(1, 6)
  -- local chutePos = Cache.chutePos
  -- everyone has a position on the board starting at 0 and wins at 100...
  local allPos = csv.parseLine(Cache.chutePos)
  local newpos = allPos[pi] + roll
  if newpos >= 100 then
    Cache.chuteState = nil
    Cache.chutePlayers = nil
    Cache.chutePos = nil
    print(curplayer .. " WINS THE WHOLE DAMN GAME HOLY SHIT!")
    return
  else
    local newpos2 = moveEel(newpos)
    if newpos2 > newpos then
      newpos = newpos2
      print(curplayer .. " rolled a " .. roll .. " and escalated up to position " .. newpos)
    elseif newpos2 < newpos then
      newpos = newpos2
      print(curplayer .. " rolled a " .. roll .. " and slid back down to to position " .. newpos)
    else
      newpos = newpos2
      print(curplayer .. " rolled a " .. roll .. " to position " .. newpos)
    end
    allPos[pi] = newpos
  end
  allPos[pi] = newpos
  Cache.chutePos = csv.toCSV(allPos)
elseif Cache.chuteState == 'join' then
  if ("," .. Cache.chutePlayers .. ","):find("," .. curplayer .. ",", 1, true) then
    print(nick, " ur thar alrdy?/iyi")
  else
    Cache.chutePlayers = Cache.chutePlayers .. "," .. curplayer
    Cache.chutePos = Cache.chutePos .. ",0"
    print(nick .. " has joined Shits and Butters")
  end
else
  Cache.chutePlayers = nick .. ",child"
  Cache.chutePos = "0,0"
  print(nick .. " is now in the game of Chutes and Bladders, type " .. etc.cmdchar .. "chute to join!")
  Cache.chuteState = 'join'
  Cache.chuteTime = os.time()
  sleep(20)
  Cache.chuteState = 'play'
  print("OK it's now time to play Chutes and Bladders, everyone type " .. etc.cmdchar .. "chute")
end

--]===]

