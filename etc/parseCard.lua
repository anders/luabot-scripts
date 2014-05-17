function go(s)
  -- \226 \153 ?
  -- 160 = spade, 163 = club, 165 = heart, 166 = diamond
  local spat = "[ %(\226]?\153?([CcSsDdHh\160\163\165\166])[LlPpIiEe]?[UuAa]?[BbDdMmRr]?[SsEeOoTt]?[SsNn]?[Dd]?[Ss]?[%) ]*"
  local vpat = "([%dJjQqKkAa%*]%d?)[AaUuIiCc]?[CcEeNn]?[KkEeGg]?[Nn]?"
  local suit, value = s:match("^ *" .. spat .. " *" .. vpat)
  if not suit or not value then
    value, suit = s:match("^ *" .. vpat .. " *o?f? *" .. spat)
  end
  if not value or not suit then
    return nil, "Unable to parse card"
  end
  if value and suit then
    value = value:lower()
    if suit == '\160' then
      suit = 's'
    elseif suit == '\163' then
      suit = 'c'
    elseif suit == '\165' then
      suit = 'h'
    elseif suit == '\166' then
      suit = 'd'
    else
      suit = suit:lower()
    end
  end
  local c, cerr = _createCard(value, suit)
  if not c then
    return c, cerr
  end
  local cardMT = {
    __tostring = _cardsString,
  }
  setmetatable(c, cardMT)
  return c
end

--[[
do -- Tests:
  local function check(s, value, suit)
    local c = go(s)
    assert(c and c.value == value and c.suit == suit,
      "Check fail for '" .. s .. "': "
        -- .. "(value=" .. (x or "<nil>") .. ",  suit=" .. (suit or "<nil>") .. ")"
        .. etc.t(c or {})
      )
  end
  
  check("9 of hearts", '9', 'Heart')
  check("♠6", '6', 'Spade')
  check("10 ♥", '10', 'Heart')
  check("(Club)10", '10', 'Club')
  check("diamonds jack", 'Jack', 'Diamond')
end
--]]

return go(arg[1] or '')
