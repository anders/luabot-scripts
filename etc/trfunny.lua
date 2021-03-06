-- Usage: set a word redefine via 'trfunny foo -> bar, get a funny translation via 'trfunny all your base

if (arg[1] or ""):find("[%-=]>.*;") then
  local n = 0
  local pos = 1
  local str = arg[1]
  for b4, af in str:gmatch("();()") do
    etc.trfunny(str:sub(pos, b4 - 1), "loop")
    pos = af
    n = n + 1
  end
  etc.trfunny(str:sub(pos, str:len()), "loop")
  n = n + 1
  print(etc.trfunny("Done setting " .. n .. " words"))
else
  require "storage"
  local lookup = storage.load(io, "lookup.tr", 2)
  -- print('arg[1]', arg[1])
  local a, c = (arg[1] or ""):match("^ *([^ ]+) *[%-=]> *([^;]-) *$")
  if c then
    require "spam"
    spam.detect(Cache, "trfunny", 20, 2)
    a = a:lower()
    local maxwordlen = 16
    local maxnewlen = maxwordlen
    if c:find("%%.*%%") then
      maxnewlen = maxwordlen * 4
    end
    if a:len() > maxwordlen or c:len() > maxnewlen then
      error(etc.trfunny("Word too long for " .. a))
    end
    if a == c then
      -- If they're the same, then just unset it.
      lookup[a] = nil
    else
      lookup[a] = c
    end
    -- print('set', a, '=', c)
    assert(storage.save(lookup))
    if arg[2] ~= "loop" then
      print(etc.trfunny("Done"))
    end
  else
  
    -- LocalCache.tr = arg[1]:sub(1, 200)
    
    local wantraw = false
    return etc.translateWords(arg[1] or "", function(w)
      if w == '-raw' then
        wantraw = true
        return "raw:"
      end
      local nw = lookup[w:lower()]
      if nw and not wantraw then
        nw = dbotscript(nw, w)
      end
      return nw
    end)
    
  end
end
