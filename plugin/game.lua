require 'json'

local LOG = plugin.log(_funcname);

local function checktrust()
  if allCodeTrusted then
    LOG.debug("allCodeTrusted = true")
  else
    LOG.warn("allCodeTrusted = false", "whyNotCodeTrusted =", whyNotCodeTrusted)
  end
end

checktrust()

assert(print == directprint, "You can't pipe the output of a game")

M = {}

---
M.minPlayers = 2
---
M.maxPlayers = 5
---
M.location = "global"
---
M.name = "Untitled Game"
---
M.bufferOutput = true
--- Game is forgotten if idle this long.
M.gameTimeout = 60 * 5

M.wantReenter = true


local function safename(x)
  local y = x:lower():gsub("[^a-z0-9_#]", "_")
  if y:len() == 0 then
    y = '_'
  end
  return y
end


local realhalt = halt
function halt()
  LOG.debug("halt")
  realhalt()
end


local function _patchGame(t)
  local mt = { __index = function(t, k)
      if type(k) == "string" then
        local lk = k:lower()
        -- M.print("looking for ", lk, "in", etc.t(t, false))
        for i, v in ipairs(t) do
          if v.nick:lower() == lk then
            return v
          end
        end
      end
      return rawget(t, k)
    end,
  }
  setmetatable(t.players, mt)
  return t
end


local function _templateGame()
  local t = {
    players = {}, -- Array and index by lowercase name.
    gstate = {},
  }
  _patchGame(t)
  return t
end


local function _Minit(G, cmdname, gamename, basedir)
  if type(cmdname) == "string" then
    cmdname = cmdname:match("[^'%.]+$")
  end
  assert(type(G) == "table", "bad _G")
  assert(type(G.io) == "table" and _G.io.fs, "bad _G")
  assert(type(G.Cache) == "table", "bad _G")
  assert(etc[cmdname], "Invalid cmdname")
  Private.game_G = G
  Private.game_cmdname = cmdname
  local io = G.io
  basedir = basedir or "gamedata"
  G.os.mkdir(basedir)
  M.name = gamename or M.name
  
  io.fs.mkdir(basedir)
  
  Private.game_fn = basedir .. "/" .. safename(cmdname) .. "." .. safename(dest)
  
  if M.bufferOutput then
    Private.game_output = {}
  end
  
  local f = io.open(Private.game_fn, 'r')
  if not f then
    -- return false, 'unable to open game state'
    Private.game_data = _templateGame()
    return true, 'new'
  end

  local dd = f:read('*a')
  f:close()
  
  Private.game_data = json.decode(dd)
  if not Private.game_data then
    M.print("UNABLE TO DECODE GAME DATA!")
    -- return false, 'unable to decode state'
    Private.game_data = _templateGame()
    return true, 'new'
  end
  
  if (Private.game_data.ts or 0) < os.time() - M.gameTimeout then
    -- Old game, start a new one.
    LOG.warn("gameTimeout")
    Private.game_data = _templateGame()
    return true, 'new'
  end
  
  _patchGame(Private.game_data)
  return true, 'resume'
end


--- Call this function every single time. Set G to _G
--- Calls game_load(game_control, str) if it exists.
function M.init(G, cmdname, gamename, basedir)
  local ok, str = _Minit(G, cmdname, gamename, basedir)
  if ok then
    local f = G.Private.game_load or G.game_load
    if f then
      f(Private.game_control, str)
    end
  end
  return ok, str
end


--- Called automatically as players use game commands.
function M.save(keep)
  local io = Private.game_G.io
  assert(Private.game_fn and Private.game_data, "Game not loaded")
  if keep == false then
    io.fs.remove(Private.game_fn)
    return true
  end
  if true then
    Private.game_data.ts = os.time()
    -- print(" SAVING GAME DATA *t =", assert(etc.t(Private.game_data, false)))
    local f = assert(io.open(Private.game_fn .. ".saving", 'w'))
    local jsonstr, b = json.encode(Private.game_data)
    if not jsonstr then
      LOG.error("Unable to serialize as JSON: " .. etc.t(Private.game_data, false))
      assert(false, "Problem encoding JSON: " .. tostring(b))
    end
    assert(f:write(jsonstr))
    f:close()
    io.fs.rename(Private.game_fn, Private.game_fn .. ".prev")
    io.fs.rename(Private.game_fn .. ".saving", Private.game_fn)
    io.fs.remove(Private.game_fn .. ".prev")
  end
  return true
end


local wrapflags = { result = true }

--- Flush output if bufferOutput is true.
function M.flushOutput(maybe_more)
  LOG.debug("flushOutput", maybe_more or false)
  local mergelinesep = " | "
  if Private.game_output and #Private.game_output > 0 then
    -- LOG.debug("game_output", etc.t(Private.game_output))
    local ml = Output.maxLines or 4 - (Private.game_output_nlines or 0)
    if maybe_more and ml <= 2 then
      -- Not enough room left, so conserve.
      return
    end
    if maybe_more then
      ml = math.floor(ml / 2)
    end
    local pr
    if #Private.game_output > ml then
      pr = table.concat(Private.game_output, mergelinesep)
    else
      pr = table.concat(Private.game_output, "\n")
    end
    if not pr then
      LOG.debug("buffered output is nil")
    else
      pr = etc.wrap(pr, wrapflags)
      assert(pr, "etc.wrap caused pr to be nil")
      print(pr)
      Private.game_output = {}
      Private.game_output_nlines = (Private.game_output_nlines or 0) + etc.wcl(pr or '')
    end
  end
  --[[
  if not maybe_more then
    LocalCache.lastgamelog = LOG.url
  end
  --]]
  if not maybe_more then
    checktrust()
    if not allCodeTrusted then
      print("WARN: allCodeTrusted = false, due to", whyNotCodeTrusted)
    end
  end
end


local function addPlayer(who)
  who = who or nick
  if #Private.game_data.players >= M.maxPlayers then
    return false, 'Too many players'
  end
  local key = who:lower()
  local p = Private.game_data.players[key]
  if p then
    return false, 'Already in the game'
  end
  if not p then
    local index = #Private.game_data.players + 1
    p = { nick = who, index = index }
    Private.game_data.players[index] = p
  end
  return true
end


local function getPlayerData(who)
  who = who or nick
  if type(who) == "number" then
    return Private.game_data.players[who]
  elseif type(who) == "table" then
    assert(who.nick, "Invalid player")
    return who
  else
    return Private.game_data.players[who:lower()]
  end
end


local function playerTurn()
  local p = getPlayerData(Private.game_data.curplayer)
  do
    local f = Private.game_G.Private.game_wait_turn or Private.game_G.game_wait_turn
    if f then
      f(Private.game_control, p)
    end
  end
  --[[if p.isBot then
    -- Used to do game_bot_turn, but moved to expect.
  end--]]
end


local function nextPlayer(who)
  assert(Private.game_data.curplayer, "nextPlayer: game not started")
  if not who then
    who = Private.game_data.curplayer + 1
    if who > #Private.game_data.players then
      who = 1
    end
  end
  local p = getPlayerData(who)
  assert(p, "nextPlayer: not a valid player: " .. tostring(who))
  assert(p.index)
  LOG.debug("Switching to player:", p.nick or "???")
  Private.game_data.curplayer = p.index
  playerTurn() -- Triggers next event, so we should halt after this.
  M.save()
  if not p.isBot then
    M.flushOutput()
    halt()
  end
end


local function abandonGame()
  LOG.debug("abandonGame")
  M.expect() -- Clear reenters.
  Private.game_data = _templateGame()
  M.save(false)
  M.print("The game of " .. M.name .. " has been abandoned, thanks Obama")
  M.flushOutput()
  halt() -- Prevent infinite loops etc. such as with a bot.
end


local function gameover(winner)
  LOG.debug("gameover")
  M.expect() -- Clear reenters.
  local k = false
  if winner then
    local p = getPlayerData(winner)
    if p then
      k = true
      M.print(p.nick .. " WINS! GAME OVER " .. M.name)
    end
  end
  Private.game_data = _templateGame()
  M.save(false)
  if not k then
    M.print("GAME OVER " .. M.name)
  end
  M.flushOutput()
  halt() -- If not halt, a bot could try to play after this.
end


--- Print game details to the players.
--- This function allows buffering and ensuring all game output fits.
function M.print(...)
  LOG.info("print:", ...)
  if Private.game_output then
    -- NOTE: doesn't consider if one print has multiple lines.
    local x = etc.getOutput(function(...)
      print(...)
    end, ...)
    if x and x ~= "" then
      Private.game_output[#Private.game_output + 1] = x
    end
  else
    print(...)
  end
end


--- Explicit reenter can preempt a bot.
function M.reenter(...)
  M.flushOutput()
  Private.game_data.expecting = select(1, ...)
  M.save()
  if M.wantReenter then
    LOG.debug("reenterFunc:", 'etc.' .. Private.game_cmdname, 90, ...)
    LOG.debug(reenterFunc('etc.' .. Private.game_cmdname, 90, ...))
    return
  else
    if select(1, ...) then
      LOG.debug("Not using reenter")
      halt()
    end
  end
end


--- Expect certain input from the current player.
--- If the current player is a bot, nothing happens.
function M.expect(...)
  local p = getPlayerData(Private.game_data.curplayer)
  if p and p.isBot then
    local first = select(1, ...)
    -- M.flushOutput(true) -- Doesn't work if back/forth within bot.
    Private.game_data.expecting = first
    M.save()
    if not first then
      -- Just clearing the expect, so don't do anything else.
      return
    end
    -- return
    -- Moved from nextTurn:
    LOG.debug("bot's turn:", p.nick or '???')
    local bpf = Private.game_G.Private.game_bot_turn or Private.game_G.game_bot_turn
    if bpf then
      LOG.debug("game_bot_turn")
      bpf(Private.game_control, p, function(...)
          nick = p.nick -- Important, switch to the bot's nick now!
          M.print("<" .. p.nick .. ">", ...)
          M.handleCmd(...)
        end, Private.game_data.expecting)
    end
    return
  end
  return M.reenter(...)
end


Private.game_control = {
  --- game_control
  nextPlayer = nextPlayer,
  --- game_control
  getPlayerData = getPlayerData,
  --- game_control
  abandonGame = abandonGame,
  --- game_control
  gameover = gameover,
  --- game_control
  getGameData = function()
    return Private.game_data
  end,
  --- game_control
  inState = function(x)
    return Private.game_data.gstate[x]
  end,
  --- game_control
  halt = function()
    -- Ensures output is flushed before the halt.
    M.flushOutput()
    halt()
  end,
  --- game_control: When bool = false, all nested states x.* are cleared as well!
  setState = function(x, bool)
    local y
    if bool == false then
      y = nil
    else
      y = true
    end
    Private.game_data.gstate[x] = y
    if not y then
      local xlen = #x
      for k, v in pairs(Private.game_data.gstate) do
        if #k > xlen and k:sub(1, xlen) == x and k:sub(xlen + 1, xlen + 1) == '.' then
          Private.game_data.gstate[k] = nil
        end
      end
    end
  end,
  --- game_control
  inUserState = function(user, x)
    local p = getPlayerData(user)
    if p and p.gstate then
      return p.gstate[x]
    end
    return false
  end,
  --- game_control: When bool = false, all nested states x.* are cleared as well!
  setUserState = function(user, x, bool)
    local y
    if bool == false then
      y = nil
    else
      y = true
    end
    local p = getPlayerData(user)
    if p then
      p.gstate = p.gstate or {}
      p.gstate[x] = y
      if not y then
        local xlen = #x
        for k, v in pairs(p.gstate) do
          if #k > xlen and k:sub(1, xlen) == x and k:sub(xlen + 1, xlen + 1) == '.' then
            p.gstate[k] = nil
          end
        end
      end
    end
    return false, 'User not in game'
  end,
}


--- Must call this with ... and don't expect the function ever to return.
function M.handleCmd(...)
  assert(Private.game_fn and Private.game_data, "Game not loaded")
  local wasexpecting = Private.game_data.expecting
  Private.game_expecting = nil
  local G = Private.game_G
  local io, os = nil, nil
  local arg1, arg2 = ...
  local isreenter = arg2 == '-reenter'
  local act, params = (arg1 or ""):match("^%s*([^ ]+)%s*(.-)%s*$")
  act = (act or ''):lower()
  -- M.print("DEBUG", "got action:", act) -- Needs bufferOutput=true to see everything, since you can't pipe output with reenter.
  LOG.debug("handleCmd nick=" .. nick .. " action=" .. act .. " all:", ...)
  if act == "join" then
    if not Private.game_data.curplayer then
      local a, b = addPlayer()
      if not a then
        M.print("Sorry, " .. nick .. ": " .. tostring(b))
      else
        local suff = ""
        local expect = "join"
        if M.getPlayerCount() >= M.minPlayers then
          suff = " There are now enough players to start playing " .. M.name .. ", just type " .. etc.cmdprefix .. Private.game_cmdname .. " start when ready" --, or the game will start automatically after 20 seconds"
          expect = "start"
        else
          suff = " Anyone else who wants to play, please type " .. etc.cmdprefix .. Private.game_cmdname .. " join now!"
        end
        M.print(nick .. " is now in the next game of " .. M.name .. "!" .. suff)
        if expect == "start" then
          M.expect("start", "join", 20)
        else
          M.expect("join", 20)
        end
      end
    else
      M.print("Sorry, " .. nick .. ": It's not time to join the game right now."
        .. " Please wait for the current game to finish, and then we can have a bunch of fun playing " .. etc.er(M.name) .. "!")
    end
  elseif act == "start" then
    if not Private.game_data.curplayer then
      local botsf = G.Private.game_bots or G.game_bots
      if botsf then
        -- game_control, playerCount, addBot(botname)
        botsf(Private.game_control, M.getPlayerCount(), function(botname)
            if addPlayer(botname) then
              local p = getPlayerData(botname)
              p.isBot = true
            end
          end)
      end
      if M.getPlayerCount() >= M.minPlayers then
        local startmsg
        do
          local f = G.Private.game_start or G.game_start
          if f then
            startmsg = f(Private.game_control)
          end
        end
        if startmsg ~= false then
          M.print(startmsg or ("The game of " .. M.name .. " has just started!"))
        end
        -- Private.game_data.curplayer = 1
        local firstplayer = math.random(M.getPlayerCount()) -- Random first player.
        Private.game_data.firstplayer = firstplayer
        Private.game_data.curplayer = firstplayer
        playerTurn() -- Halts.
      else
        M.print("There are not enough players yet to play " .. M.name .. ", make sure everyone types " .. etc.cmdprefix .. Private.game_cmdname .. " join")
      end
    else
      if not isreenter then
        M.print("The game is already started, please wait for the game to finish and then join")
      end
    end
  elseif act == "dummy" or act == '$dummy' then
    nick = '$dummy'
    return M.handleCmd(params)
  elseif act == "-timeout" and isreenter then
    if not Private.game_data.curplayer then
      M.handleCmd("start")
      M.flushOutput()
      return
    end
    if wasexpecting then
      local f = G.Private.game_timeout or G.game_timeout
      if f then
        f(game_control, wasexpecting)
      else--[[if Private.game_data.curplayer then
        M.print(Private.game_data.players[Private.game_data.curplayer].nick .. " * "
          .. "Your turn is timing out, please acknowledge your turn by using the full command: "
          .. etc.cmdchar .. Private.game_cmdname .. " " .. tostring(wasexpecting or '') .. " ... or your preferred action")
      --]]end
    end
  elseif act == "" then
    M.print("This is the game " .. M.name .. " - To start playing, type " .. etc.cmdchar .. Private.game_cmdname .. " join")
  else
    local f = G.Private["game_" .. act] or G["game_" .. act]
    local ok = false
    if f then
      local p = getPlayerData(Private.game_data.curplayer)
      if p then
        if nick:lower() == p.nick:lower() then
          ok = true
          f(Private.game_control, getPlayerData(Private.game_data.curplayer), params)
        end
      end
    end
    if not ok and not reenter then
      local suff = ""
      if not M.isPlayer(nick) then
        suff = " - to join the next game, type "
          .. etc.cmdchar .. Private.game_cmdname .. " join"
      end
      M.print(nick .. " * Unknown game action: " .. act .. suff)
      M.flushOutput()
      return false
    end
  end
  -- M.flushOutput() -- Doesn't fit bot output into maxLines. Let nextPlayer etc flush instead.
  M.save()
  LOG.debug("Nothing to do? Do you need to call nextPlayer to switch to another player, or expect to expect something from the current player?")
  M.flushOutput()
  -- halt() -- Kills potential bot's turn.
end


---
function M.getPlayerCount()
  return #Private.game_data.players
end


--- Returns true if the supplied user is the first player.
--- The game does not always start on the first index in the array.
--- Only makes sense if the players turns are in order and don't jump around.
function M.isFirstPlayer(who)
  local firstplayer = Private.game_data.firstplayer
  local firstplayerdata = Private.game_data.players[firstplayer]
  return firstplayerdata == getPlayerData(who)
end


--- Returns true if the supplied user is the last player.
--- The last player is the player before isFirstPlayer, considering wrapping.
function M.isLastPlayer(who)
  local lastplayer = Private.game_data.firstplayer - 1
  if lastplayer == 0 then
    lastplayer = #Private.game_data.players
  end
  local lastplayerdata = Private.game_data.players[lastplayer]
  return lastplayerdata == getPlayerData(who)
end


---
function M.isPlayer(checknick)
  if Private.game_data.players[(checknick or nick):lower()] then
    return true
  end
  return false
end


--- Returns false if not a player, or returns their nickname and index.
function M.getPlayer(x)
  local p = getPlayerData(x)
  if p then
    return p.nick, p.index
  end
  return false, "No such player"
end


---
function M.addDummyPlayer()
  return addPlayer('$dummy')
end


---
function M.isBot(nick)
  if type(nick) == "string" then
    nick = nick:lower()
    local isBot = false
    for i = 1, #Private.game_data.players do
      local p = Private.game_data.players[i]
      if p.isBot then
        if nick == p.nick:lower() then
          isBot = true
          break
        end
      end
    end
  end
  return false
end


---
function M.sendNotice(to, msg)
  local isBot = M.isBot(to)
  if to:sub(1, 1) == '$' then
    M.print("Notice to " .. to .. ": " .. msg,
      "(use " .. etc.cmdchar .. Private.game_cmdname
        .. " dummy <move> to control)")
  elseif not isBot then
    M.flushOutput(true) -- Consider?
    sendNotice(to, "[" .. dest .. "] " .. msg)
  end
end


--[[

local function _getCustomGameData(root, name)
  local x = root[name]
  if type(x) == "table" then
    -- If it's a table, assume it'll get dirty.
    M._dirty = true
  end
  return x
end

local function _setCustomGameData(root, name, value)
  root[name] = value
  M._dirty = true
  return true
end


function M.getCustomGameData(name)
  return _getCustomGameData(Private.game_data, 'cust-' .. name)
end

function M.setCustomGameData(name, value)
  return _setCustomGameData(Private.game_data, 'cust-' .. name, value)
end


function M.getCustomPlayerGameData(nick, name)
  local p = getPlayerData(nick)
  if not p then
    return false, 'No such player'
  end
  return _getCustomGameData(p, 'cust-' .. name)
end

function M.setCustomPlayerGameData(nick, name, value)
  local p = getPlayerData(nick)
  if not p then
    return false, 'No such player'
  end
  return _setCustomGameData(p, 'cust-' .. name, value)
end

--]]

return M
