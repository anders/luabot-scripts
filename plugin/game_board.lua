-- Usage: require'game'; require'game.board'; Call game_control.setBoard(board_array) first to get the board game setup.

local LOG = plugin.log(_funcname);

--- Board object. Represents the game's board.
--- A "spot" referred herein refers to a spot object in the board's array, which represents a spot in the game.
local M = {}
local game = require 'game';
game.board = M


--- What spot property gets the spot's text?
M.propSpotText = "spotText"

--- What spot property gets the spot's color (optional)?
--- A color is a number from the list: 1 = Black; 2 = Navy Blue; 3 = Green; 4 = Red; 5 = Brown; 6 = Purple; 7 = Olive; 8 = Yellow; 9 = Lime Green; 10 = Teal; 11 = Aqua Light; 12 = Royal Blue; 13 = Hot Pink; 14 = Dark Gray; 15 = Light Gray; 16 = White;
M.propSpotColor = nil

--- Format string indicating how a spot is to be formatted for the user. See getSpotDisplayText.
--- Preset tags: <color> and <text>
--- Tags which fetch values from the spot object can be prefixed with spot-, such as <prop-adornment/> will get the adornment value from the spot object; adornmentEnd would also be called if present, to support closing the tag.
M.spotDisplayFormat = "<color>{</color> <text/> <color>}</color>"


-- Callback gets: (tagName, isOpen, isClose)
-- isOpen and isClose can both be set if it's a self-closing tag.
function parseSimpleTags(s, callback)
  return s:gsub("<(/?)([%w%-_]+)(/?)>", function(close, tagName, selfclose)
    local isOpen = close ~= '/'
    local isClose = close == '/' or selfclose == '/'
    return callback(tagName, isOpen, isClose)
  end) or ''
end


--- board_array is an array of all the possible spots on the board game.
function Private.game_control.setBoard(board_array)
  local board = {}
  board.array = board_array
  Private.game_board = board
  return board
end


--- Roll dice and return dice object.
--- Fields: total (sum of all dice values).
--- Array is separate dice values.
--- num_dice defaults to 1, sides defaults to 6.
function Private.game_control.rollDice(num_dice, sides)
  local dice = {}
  num_dice = num_dice or 1
  sides = sides or 6
  local total = 0
  for i = 1, num_dice do
    local v = math.random(sides)
    dice[#dice + 1] = v
    total = total + v
  end
  dice.total = total
  setmetatable(dice, {
    __tostring = function(self)
      local t = {}
      for i = 1, #self do
        t[#t + 1] = "[" .. self[i] .. "]"
      end
      if #self ~= 1 then
        t[#t + 1] = "(total=" .. self.total .. ")"
      end
      return table.concat(t, "")
    end;
  })
  return dice
end


local function getPlayerPos(who)
  local board = assert(Private.game_board, "Set the board")
  local p = Private.game_control.getPlayerData(who)
  local pos = p.board_pos
  if not pos then
    pos = 1
    LOG.trace("Player " .. who .. " board game position initialized to 1")
  end
  return pos
end


local function getSpot(x)
  if type(x) == "number" then
    local board = assert(Private.game_board, "Set the board")
    return board.array[x]
  else
    return x
  end
end


local function propval(x, spot)
  if x == nil then
    return ""
  end
  if type(x) == "function" then
    local y = x(spot)
    if y == nil then
      return ""
    end
    return tostring(y)
  else
    return tostring(x)
  end
end


local function setPlayerObjPosition(p, position)
  p.board_pos = position
  local f = Private.game_G.Private.board_game_land_spot or Private.game_G.board_game_land_spot
  if f then
    local spot = Private.game_board.array[position]
    f(Private.game_control, p, spot, position)
  end
end


--- Set absolute position. Does not call board_game_moving_spot.
--- See boardAdvancePlayer for typical use.
function Private.game_control.boardSetPlayerPosition(who, position)
  local p = Private.game_control.getPlayerData(who)
  return setPlayerObjPosition(p, position)
end


--- move is either a number offset to move the player, or a dice object.
--- Calls board_game_moving_spot(game_control, player, spot, position) if it exists, before the move takes place; the player is still at the previous spot, and position is set to what the next spot would be; return a new position to override.
--- Calls board_game_land_spot(game_control, player, spot, position) if it exists, after the move takes place.
--- By default will wrap the player around the board infinitely.
function Private.game_control.boardAdvancePlayer(who, move)
  local board = assert(Private.game_board, "Set the board")
  local p = Private.game_control.getPlayerData(who)
  local pos = getPlayerPos(p.nick)
  if type(move) == "table" then
    assert(move.total, "Not a dice object")
    pos = pos + move.total
  else
    pos = pos + move
  end
  -- Wrap around:
  pos = pos % #board.array + 1
  local spot = board.array[pos]
  local fmoving = Private.game_G.Private.board_game_moving_spot or Private.game_G.board_game_moving_spot
  if fmoving then
    local xmove = fmoving(Private.game_control, p, spot, pos)
    if type(xmove) == "number" then
      pos = xmove
      spot = board.array[pos]
    end
  end
  return setPlayerObjPosition(p, pos);
end


---
function M.getPlayerPosition(who)
  return getPlayerPos(who)
end


--- Number of spots on the board.
function M.getSpotCount()
  return #assert(Private.game_board, "Set the board")
end


---
function M.getSpotDisplayText(spot)
  spot = getSpot(spot)
  return parseSimpleTags(M.spotDisplayFormat, function(tagName, isOpen, isClose)
    if tagName == "text" then
      if isOpen and spot[M.propSpotText] then
        return propval(spot[M.propSpotText], spot)
      end
    elseif tagName == "color" then
      if M.propSpotColor and propval(spot[M.propSpotColor], spot) then
        if isOpen then
          return "\0031," .. (tonumber(propval(spot[M.propSpotColor], spot)) or 0) .. "\002\002"
        end
        if isClose then
          return "\003\002\002"
        end
      end
    elseif tagName:find("^spot%-") then
      local prop = tagName:sub(6)
      if isOpen and spot[prop] then
        return propval(spot[prop], spot)
      end
      if isClose and spot[prop .. "End"] then
        return propval(spot[prop .. "End"], spot)
      end
    else
      LOG.warn("Unknown tag: " .. tagName)
    end
    return ""
  end)
end



return M
