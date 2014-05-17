require 'json'

local GOD_ACCOUNT = 2 -- anders

local WARN_TIME = 60 -- seconds (not used)

local Game

local SaveDir = 'uno-gamedata/'

local RANKS = {
  [10] = 'S', S = 10,
  [11] = 'D2', D2 = 11,
  [12] = 'R', R = 12,
  [13] = 'D4', D4 = 13,
  [14] = 'W', W = 14
}

local COLORS = {
  [1] = 'Y', Y = 1,
  [2] = 'B', B = 2,
  [3] = 'G', G = 3,
  [4] = 'R', R = 4,
  [5] = 'W', W = 5
}

function setup()
  os.mkdir(SaveDir)
end

function endgame()
  os.remove(SaveDir..chan)
  Game = nil
end

function loadgame()
  local f = io.open(SaveDir..chan, 'r')
  if not f then
    return false, 'unable to open game state'
  end

  local data = f:read('*a')
  Game = json.decode(data)
  if not Game then
    return false, 'unable to decode state'
  end

  f:close()
  return true
end

function newgame()
  Game = {
    ts = os.time(),
    clockwise = true
  }

  local f = io.open(SaveDir..chan, 'w')
  if not f then
    return false, 'unable to open game state'
  end

  f:write(json.encode(state))
  f:close()

  return true
end

function newdeck()
  Game.deck = {}
  Game.discard = {}
  
  -- create color cards
  for color=1, 4 do
    for i=0, 12 do
      table.insert(Game.deck, {
        color = color,
        rank = i
      })

      -- two of each, except 0
      if i ~= 0 then
        table.insert(Game.deck, {
          color = color,
          rank = i
        })
      end
    end
  end

  -- create wild cards
  for i=1, 4 do
    table.insert(Game.deck, {
      color = 5,
      rank = RANKS.W
    })
    
    table.insert(Game.deck, {
      color = 5,
      rank = RANKS.D4
    })
  end

  assert(#Game.deck == 108, 'expected 108 cards, have '..#Game.deck)
end

function shuffle()
  for i=#Game.deck, 1, -1 do
    local j = math.random(1, i)
    Game.deck[i], Game.deck[j] = Game.deck[j], Game.deck[i]
  end
end

function pickcard(n)
  if #Game.deck == 0 then
    -- cards ran out, taek cards from discard
    for i=2, #Game.discard do
      Game.deck[i-1] = Game.discard[i]
    end
  end
  n = n or math.random(1, #Game.deck)
  return table.remove(Game.deck, n)
end

function putback(card)
  table.insert(Game.deck, card, 1)
end

function discard(card)
  Game.discard[#Game.discard + 1] = card
end

function savegame()
  local f = io.open(SaveDir..chan, 'w')
  if not f then
    return false, 'unable to open game state file'
  end

  f:write(json.encode(Game))
  f:close()

  return true
end

function cardstr(card)
  -- return ('rank: %s; color: %s'):format(RANKS[card.rank] or card.rank, COLORS[card.color] or card.color)
  local irccolor = {
    [COLORS.Y] = 8,
    [COLORS.B] = 11,
    [COLORS.G] = 9,
    [COLORS.R] = 4,
    [COLORS.W] = 13
  }
  return ('\002\003%d,1[%s%s]\002'):format(irccolor[card.color], COLORS[card.color]:lower(), RANKS[card.rank] or card.rank)
end

function cardsstr(cards)
  local tmp = {}
  for i=1, #cards do
    tmp[i] = cardstr(cards[i])
  end
  return table.concat(tmp, '')..'\003'
end

function addplayer(user)
  user = user:lower()
  assert(Game)
  local id

  Game.nick2player = Game.nick2player or {}
  Game.player2nick = Game.player2nick or {}
  Game.players = Game.players or {}

  if not Game.nick2player[user] then
    Game.players[#Game.players + 1] = {
      cards = {}
    }
    id = #Game.players
    Game.nick2player[user] = id
    Game.player2nick[id] = user
  else
    return false, 'player already in game'
  end

  savegame()
  return true, id
end

function doturn()
  if not Game.currentplayer then
    Game.currentplayer = 1
  end

  if not Game.turnid then
    Game.turnid = 1
  else
    Game.turnid = Game.turnid + 1
  end

  checkturn()

  local pl = Game.players[Game.currentplayer]
  local pnick = Game.player2nick[Game.currentplayer]

  print(pnick.."'s turn. top card: "..cardstr(Game.discard[#Game.discard]))
  savegame()

  local nextpid = getnextid()
  local nextp = Game.players[nextpid]
  local nextname = Game.player2nick[nextpid]
  
  local cardsstr = {}
  for i=1, #Game.players do
    local name = Game.player2nick[i]
    cardsstr[#cardsstr+1] = name..': '..(#Game.players[i].cards)..' card(s)'
  end
  
  showcards(Game.currentplayer, '(next player: '..nextname..'; '..table.concat(cardsstr, '; ')..')')
end

function showcards(id, extra)
  extra = extra and (' '..extra) or ''
  local pl = Game.players[id]
  local pnick = Game.player2nick[id]
  sendNotice(pnick, 'your cards: '..cardsstr(pl.cards)..extra)
end

function pl_findcard(color, rank)
  local cards = Game.players[Game.currentplayer].cards
  for k, card in ipairs(cards) do
    if card.rank == rank then
      if card.color == color or card.color == COLORS.W then
        return true, k, card
      end
    end
  end
  return false
end

function pl_getcard(id)
  return Game.players[Game.currentplayer].cards[id]
end

function pl_pickcard(id)
  return table.remove(Game.players[Game.currentplayer].cards, id)
end

function playable(card)
  local top = Game.discard[#Game.discard]
  if top.rank == card.rank then return true end
  if top.color == card.color then return true end
  if top.color == COLORS.W or card.color == COLORS.W then return true end
  return false
end

function play(card_id, color)
  local pl = Game.players[Game.currentplayer]
  local plid = Game.currentplayer

  local card = pl_pickcard(card_id)
  assert(playable(card), 'card is not playable, yet play() was called')
  
  discard(card)
  
  if card.rank == RANKS.W or card.rank == RANKS.D4 then
    card.color = color
  end
  
  if card.rank == RANKS.D2 or card.rank == RANKS.D4 then
    -- draw cards
    local todraw
    if card.rank == RANKS.D2 then
      todraw = 2
    elseif card.rank == RANKS.D4 then
      todraw = 4
    end
    local nextplayer = getnextid()
    local nextnick = Game.player2nick[nextplayer]
    local cards = Game.players[nextplayer].cards
    local t = {}
    for i=1, todraw do
      cards[#cards + 1] = pickcard()
      t[#t + 1] = cards[#cards]
    end
    sendNotice(nextnick, 'Drawn cards: '..cardsstr(t))
    print(nextnick..' draws '..todraw..' cards and is skipped')
    nextturn()
  elseif card.rank == RANKS.R then
    -- reverse order
    Game.clockwise = not Game.clockwise
    nextturn()
    print('order: '..(Game.clockwise and 'clockwise' or 'counter-clockwise'))
  elseif card.rank == RANKS.S then
    -- skip
    print('skipping '..Game.player2nick[getnextid()])
    nextturn()
  end
  
  if #pl.cards == 1 then
    print('UNO! '..Game.player2nick[plid]..' has ONE card left!')
  elseif #pl.cards == 0 then
    print(Game.player2nick[plid]..' won the game!!!!')
    endgame()
    return
  end
  
  nextturn()
  doturn()
end

function getnextid()
  local id = Game.currentplayer
  if Game.clockwise then
    id = id + 1
    if id > #Game.players then id = 1 end
  else
    id = id - 1
    if id < 1 then id = #Game.players end
  end
  
  return id
end

function nextturn()
  Game.currentplayer = getnextid()
  Game.players[Game.currentplayer].drawn = nil
end

function checkturn()
  assert(Game and Game.started, 'game must be in progress')
  local player_id = Game.currentplayer
  local turnid = Game.turnid
--  setTimeout(function()
--    if turnid == Game.turnid then
--      print(Game.player2nick[player_id]..': HEY! SLEEPYHEAD! wakey wakey hands off snakey!')
--    end
--  end, WARN_TIME * 1000)
end

function main(input)
  if not input then input = '' end

  local args = {}
  for w in input:gmatch('[^%s]+') do
    args[#args + 1] = w
  end

  if #input == 0 or args[1] == 'new' then
    loadgame()
    if Game then
      if os.time() < Game.ts + 3600 then
        -- game still 'fresh'
        if Game.started then
          print('game already started, wait until finish')
        else
          print("game already starting, use 'uno join")
        end
        return
      else
        print('old game expired...')
      end
    end

    assert(newgame())
    assert(addplayer(nick))
    print("game started by "..nick..", type 'uno join to join")

  elseif args[1] == 'join' then
    loadgame()
    if not Game then
      print('no game in progress')
      return
    end

    if Game.started then
      print('game already started')
      return
    end
    
    local status, err = addplayer(nick)
    if not status then
      print(err)
      return
    else
      print(nick..' joined the game as player #'..err)
      if #Game.players >= 2 then
        print("there are enough players, type 'uno deal to start.")
      end
    end

  elseif args[1] == 'cards' then
    assert(loadgame())
    if not Game.started then
      print('game not started')
      return
    end
    
    local id = Game.nick2player[nick:lower()]
    if not id then
      print(nick..': you are not in the game, bugger off')
      return
    end
    
    showcards(id)
    
  elseif args[1] == 'deal' then
    assert(loadgame())

    if Game.started then
      print(nick..': game already in progress')
      return
    end

    Game.started = true
    newdeck()
    shuffle()

    -- deal 7 cards to each player
    for id, player in ipairs(Game.players) do
      for i=1, 7 do
        player.cards[#player.cards + 1] = pickcard()
      end
    end
    
    -- get top card (can't be wild 4)
    while true do
      local card = pickcard(#Game.deck)
      if card.color == 5 and card.rank == RANKS.D4 then
        putback(card)
      else
        discard(card)
        break
      end
    end
    
    doturn()
    
    savegame()
    
  elseif args[1] == 'draw' then
    if not loadgame() then
      print(nick..': unable to load game state')
      return
    end
    
    if not Game.started then
      print(nick..': game not started yet')
      return
    end
    
    local id = Game.nick2player[nick:lower()]
    if not id then
      print(nick..': you are not in the game, bugger off')
      return
    end

    if Game.currentplayer ~= id then
      print(nick..': it\'s not your turn')
      return
    end
    
    if not Game.players[id].drawn then
      Game.players[id].drawn = true
      local card = pickcard()
      Game.players[id].cards[#Game.players[id].cards + 1] = card
      sendNotice(nick, 'drew card: '..cardstr(card)..'\003 if you can\'t play, then use \'uno pass')
    else
      print(nick..": you already drew a card, you could use 'uno pass to skip your turn")
    end
    
    savegame()
    
  elseif args[1] == 'pass' or args[1] == 'skip' then
    if not loadgame() then
      print(nick..': unable to load game state')
      return
    end
    
    if not Game.started then
      print(nick..': game not started yet')
      return
    end
    
    local id = Game.nick2player[nick:lower()]
    if not id then
      print(nick..': you are not in the game, fuck *ff')
      return
    end

    if Game.currentplayer ~= id then
      print(nick..': it\'s not your turn')
      return
    end
    
    if not Game.players[id].drawn then
      print(nick..': draw a card first id*ot')
      return
    end
    
    nextturn()
    doturn()
    
  elseif args[1] == 'play' then
    if not loadgame() then
      print(nick..': unable to load game state. did you want to start a new game? use \'uno')
      return
    end

    if not Game.started then
      print(nick..': game not started yet')
      return
    end

    local id = Game.nick2player[nick:lower()]
    if not id then
      print(nick..': you are not in the game, bugger off')
      return
    end

    if Game.currentplayer ~= id then
      print(nick..': it\'s not your turn')
      return
    end

    local color, rank = args[2], args[3]
    if color and not rank then
      color, rank = color:match('([rgby])([DdRrSsWw%d]+)')
    end
    
    if not rank then
      print("use 'uno play color rank. to play a wild, just choose a new color")
      print("color: r, g, b, y; rank: 0-9, d2, d4, r, s, w")
      return
    end
    
    color = color:upper()
    rank = rank:upper()

    if color == 'R' or color == 'RED' then
      color = COLORS.R
    elseif color == 'G' or color == 'GREEN' then
      color = COLORS.G
    elseif color == 'B' or color == 'BLUE' then
      color = COLORS.B
    elseif color == 'Y' or color == 'YELLOW' then
      color = COLORS.Y
    else
      print('unknown color! try r, g, b, y (if you want to play a wild card, pick a color)')
      return
    end

    if RANKS[rank] then
      rank = RANKS[rank]
    else
      local n = tonumber(rank)
      if n >= 0 and n <= 9 then
        rank = n
      else
        print(nick..': invalid rank, try 0-9, d2, d4, r, s, w')
        return
      end
    end

    local have_card, card_id, card = pl_findcard(color, rank)
    if not have_card then
      print(nick..': please idiot, you dont have that card...')
      return
    end

    if not playable(card) then
      print(nick..': you cant play that card right now.')
      return
    end
    
    play(card_id, color)
  elseif args[1] == 'top' then
    if not loadgame() then
      print(nick..': no game')
      return
    end
    local topcard = Game.discard[#Game.discard]

    print(nick..': top card: '..cardstr(topcard))
  elseif args[1] == 'turn' then
    if not loadgame() then return end
    if not Game.started then return end
    local pid = Game.currentplayer
    local pnick = Game.player2nick[pid]
    print(nick..': current player: '..pnick)
    
  elseif args[1] == 'players' then
    if not loadgame() then return end
    local t = {}
    for k, player in ipairs(Game.players) do
      t[#t+1] = Game.player2nick[k]
      if player.cards then
        t[#t] = t[#t]..' ('..#player.cards..')'
      end
    end
    print(table.concat(t, ', '))
    
  elseif args[1] == 'help' or args[1] == 'commands' then
    print("UNO commands: 'uno [play|top|join|draw|pass|deal|cards|turn|players]")
    
  elseif args[1] == 'god-reset' and account == GOD_ACCOUNT then
    os.remove(SaveDir..chan)
    print 'Game reset.'
 
  elseif args[1] == 'god-init' and account == GOD_ACCOUNT then
    nick = 'anders'; etc.uno 'god-reset'
    nick = 'anders'; etc.uno()
    nick = 'iClown'; etc.uno 'join'
    
  elseif args[1] == 'god' and account == GOD_ACCOUNT then
    local rest = input:match('[^%s]+ [^%s]+ (.+)')
    print(("simulating <%s> 'uno %s"):format(args[2], rest))
    nick = args[2]; etc.uno(rest)
    
  end
end

if not Editor then
  main(arg[1])
end