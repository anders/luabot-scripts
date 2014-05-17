if Editor then return end

local LOG = plugin.log(_funcname);

gamename = _funcname:match("[^%.]+$") or "?"

require 'game'
require 'game.board'


game.gameTimeout = 60 * 60 -- Set this pretty high since the game is so long


local Type_PassGo = 1
local Type_Property = 2
local Type_ChestCard = 3
local Type_Tax = 4
local Type_HopeCard = 5
local Type_Jail = 6
local Type_Services = 7 -- electric/water company
local Type_Station = 8
local Type_Parking = 9
local Type_GoToJail = 10

local GroupColors = {
  6,
  11,
  13,
  7,
  4,
  8,
  3,
  12,
}

local board = {
  {type = Type_PassGo, name = "Clown Home" },
  {type = Type_Property, group = 1, name = "Carnival Ave" },
  {type = Type_ChestCard, name = "Clown Chest" },
  {type = Type_Property, group = 1, name = "Masquerade Ln" },
  {type = Type_Tax, amount = 200, name = "Pay Taxes!" },
  {type = Type_Station, base = 200, name = "Clown Train #1" }, -- fixme: base price
  {type = Type_Property, group = 2, name = "Wm4 Land" },
  {type = Type_HopeCard, name = "Hope Card" },
  {type = Type_Property, group = 2, name = "Butt City" },
  {type = Type_Property, group = 2, name = "Likes Cake" },
  {type = Type_Jail, name = "Clown Cage" },
  {type = Type_Property, group = 3, name = "Anders Land" },
  {type = Type_Services, name = "Pay your utilities" },
  {type = Type_Property, group = 3, name = "CBA" },
  {type = Type_Property, group = 3, name = "YOLO" },
  {type = Type_Station, base = 200, name = "Clown Train #2"}, -- fixme: base price
  {type = Type_Property, group = 4, name = "Byte[] Land"},
  {type = Type_ChestCard, name = "Clown Chest" },
  {type = Type_Property, group = 4, name = "Byte Ln" },
  {type = Type_Property, group = 4, name = "Colon P" },
  {type = Type_Parking, name = "Free Parking" },
  {type = Type_Property, group = 5, name = "Tent Place" },
  {type = Type_HopeCard, name = "Hope Card" },
  {type = Type_Property, group = 5, name = "Illiterate Ave" },
  {type = Type_Property, group = 5, name = "Hello World"},
  {type = Type_Station, base = 200, name = "Clown Train #3"}, -- fixme: base price
  {type = Type_Property, group = 6, name = "Hello Gentlemen" },
  {type = Type_Property, group = 6, name = "Main Screen"},
  {type = Type_Services, name = "Pay your utilities"},
  {type = Type_Property, group = 6, name = "Move Zig"},
  {type = Type_GoToJail, name = "Go directly into the Clown Cage!" },
  {type = Type_Property, group = 7, name = "Hunter Two"},
  {type = Type_Property, group = 7, name = "Linux"},
  {type = Type_ChestCard, name = "Clown Chest" },
  {type = Type_Property, group = 7, name = "Platform St"},
  {type = Type_Station, base = 200, name = "Clown Train #4"},
  {type = Type_HopeCard, name = "Hope Card" },
  {type = Type_Property, group = 8, name = "Four of a Kind" },
  {type = Type_Tax, amount = 100, name = "Pay Taxes!" }, -- fixme price
  {type = Type_Property, group = 8, name = "Blackjack" },
}
board.__index = {}

local jailPosition = nil

for i = 1, #board do
  setmetatable(board[i], board)
  if board[i].type == Type_Jail then
    assert(not jailPosition, "Two jails?")
    jailPosition = i
  end
end

game.board.propSpotColor = "spotColor"


function board.__index.spotText(spot)
  return rawget(spot, 'name') or ("type=" .. spot.type)
end


function board.__index.spotColor(spot)
  if rawget(spot, 'group') then
    return GroupColors[spot.group]
  end
end


local playerGoToJail -- forward decl


local function action_clownhome(game_control, player)
  -- go thar
end


function action_cash_func(amount)
  return function(game_control, player)
    -- diff money amount
  end
end


local chestcards = {
  { text = "Advance to Clown Home (Collect $200)", action = action_clownhome, },
  { text = "Clown error in your favor – collect $75", action = action_cash_func(75), },
  { text = "Clown's fees – Pay $50", action = action_cash_func(-50), },
  { text = "Get out of Clown Cage free – this card may be kept until needed, or sold", },
  { text = "Go directly to Clown Cage – Do not pass Clown Home, do not collect $200", action = playerGoToJail, },
  { text = "It is your birthday Collect $10 from each player", },
  { text = "Grand Circus Night – collect $50 from every player for opening night seats", },
  { text = "Income Tax refund – collect $20", action = action_cash_func(20), },
  { text = "Life Insurance Matures – collect $100", action = action_cash_func(100), },
  { text = "Pay Circus Fees of $100", action = action_cash_func(-100), },
  { text = "Pay Clown Tent Fees of $50", action = action_cash_func(-50), },
  { text = "Receive $25 Consultancy Fee", action = action_cash_func(-25), },
  { text = "You are assessed for street repairs – $40 per house, $115 per hotel", },
  { text = "You have won second prize in a beauty contest– collect $10", action = action_cash_func(10), },
  { text = "You inherit $100", action = action_cash_func(100), },
  { text = "From sale of stock you get $50", action = action_cash_func(50), },
  { text = "Holiday Fund matures - Receive $100", action = action_cash_func(100), },
}

local hopecards = {
  { text = "Advance to Clown Home (Collect $200)", action = action_clownhome, },
  { text = "Advance to Illiterate Ave.", },
  { text = "Advance token to nearest Utility. If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total ten times the amount thrown.", },
  { text = "Advance token to the nearest Clown Train and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank.", },
  { text = "Advance token to the nearest Clown Train and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank.", },
  { text = "Advance to Tent Place – if you pass Go, collect $200", },
  { text = "Bank pays you dividend of $50", action = action_cash_func(50), },
  { text = "Get out of Clown Cage – this card may be kept until needed, or traded/sold", },
  { text = "Go back 3 spaces", },
  { text = "Go directly to Clown Cage – do not pass Clown Home, do not collect $200", action = playerGoToJail, },
  { text = "Make general repairs on all your property – for each house pay $25 – for each hotel $100", },
  { text = "Pay poor tax of $15", action = action_cash_func(-15), },
  { text = "Take a trip to Clown Train #2 – if you pass Go collect $200", },
  { text = "Take a walk on the Blackjack – advance token to Blackjack!", },
  { text = "You have been elected chairman of the board – pay each player $50", },
  { text = "Your building loan matures – collect $150", action = action_cash_func(150), },
  { text = "You have won a crossword competition - collect $100", action = action_cash_func(100), },
}


function game_load(game_control, str)
  game_control.setBoard(board)
  local gamedata = game_control.getGameData()
  gamedata.props = gamedata.props or {} -- Keeps track of the state of all the properties. Indexed by spot position.
end


function game_bots(game_control, playerCount, addBot)
  if playerCount < 2 then
    addBot("Abbot")
  end
end


function game_wait_turn(game_control, player)
  game.print("It is " .. player.nick .. "'s turn, please type: " .. etc.cmdprefix .. gamename .. " roll")
  game.expect("roll")
end


function game_bot_turn(game_control, bot, botInput, expecting)
  LOG.debug("It's bot's turn, expecting:", expecting)
  botInput(expecting)
end


-- Always return immediately after this function.
function playerGoToJail(game_control, player)
  -- local gamedata = game_control.getGameData()
  player.jail = 0
  game.print("GO TO JAIL ASSHOLE!")
  game_control.boardSetPlayerPosition(player.nick, jailPosition)
  game_control.nextPlayer()
end


function game_roll(game_control, player, param)
  LOG.info(player.nick, "roll")
  local gamedata = game_control.getGameData()
  local dice = game_control.rollDice(2)
  if dice[1] == dice[2] then
    if player.jail then
      print("You rolled a double, you are now out of the Clown Cage")
      -- You get out of jail but it doesn't count as a usual double.
      gamedata.rolledDouble = 0
      player.jail = nil
    else
      gamedata.rolledDouble = (gamedata.rolledDouble or 0) + 1
      if gamedata.rolledDouble == 3 then
        gamedata.rolledDouble = 0 -- Reset for next guy.
        game.print("ROLLED 3 DOUBLES IN A ROW")
        playerGoToJail(game_control, player)
        return
      end
    end
  else
    gamedata.rolledDouble = 0
  end
  if player.jail then
    player.jail = player.jail + 1
    if player.jail == 3 then
      print("You can get out of the Clown Cage now")
      game_control.boardAdvancePlayer(player.nick, dice)
    else
      print("You are STILL in the Clown Cage")
      -- game_control.nextPlayer()
      game_control.boardAdvancePlayer(player.nick, 0)
    end
  else
    game.print(player.nick, "rolled:", tostring(dice))
    game_control.boardAdvancePlayer(player.nick, dice)
  end
end


local function turnOver(game_control, player)
  local gamedata = game_control.getGameData()
  if gamedata.rolledDouble > 0 then
    game.print("Rolled a double, you get to go again!")
    game_control.nextPlayer(player.nick) -- Same player.
  else
    game_control.nextPlayer()
  end
end


function board_game_land_spot(game_control, player, spot, position)
  assert(position, "board_game_land_spot: bad position")
  assert(spot, "board_game_land_spot: bad spot")
  LOG.info("Moving to", position)
  local gamedata = game_control.getGameData()
  -- LOG.trace("getting spot text")
  game.print(player.nick, "*", game.board.getSpotDisplayText(spot))
  -- LOG.trace("got spot text")
  if spot.type == Type_Property then
    -- TODO: check if property owned...
    if gamedata.props[position] then -- If set, it's owned
      game.print("This property is owned by " .. (gamedata.props[position].owner or "somebody"))
    else
      game.print("Would you like to buy this property? yes/no")
      game.expect("yes", "no")
      return
    end
  elseif spot.type == Type_GoToJail then
    playerGoToJail(game_control, player)
  elseif spot.type == Type_ChestCard then
    game.print("A Chest Card would say: " .. chestcards[math.random(#chestcards)].text)
    game.print("But the card doesn't do anything yet!")
  elseif spot.type == Type_HopeCard then
    game.print("A Hope Card would say: " .. hopecards[math.random(#hopecards)].text)
    game.print("But the card doesn't do anything yet!")
  else
    game.print("NOTHING TO DO HERE!")
  end
  turnOver(game_control, player)
end


function game_yes(game_control, player, param)
  LOG.info(player.nick, "yes")
  LOG.debug(player.nick, "You said yes")
  local gamedata = game_control.getGameData()
  local position = game.board.getPlayerPosition(player.nick)
  assert(position, "game_yes can't find your position")
  -- Make sure they have enough money.
  if true then
    gamedata.props[position] = {
      owner = player.nick,
    }
    game.print("It's yours! FOR FREE! somehow")
  else
    -- Shouldn't get here; don't have the option.
    -- But keep it in case something happens between question/answer.
    game.print("You can't afford it!")
  end
  turnOver(game_control, player)
end


function game_no(game_control, player, param)
  LOG.info(player.nick, "no")
  LOG.debug(player.nick, "You said no")
  game.print("You don't want that")
  game_control.nextPlayer()
end


-- These must go last to setup and handle the game:
assert(game.init(_G, gamename, 'The Game of Clownopoly'))
game.handleCmd(...)
