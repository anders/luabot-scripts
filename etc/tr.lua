-- Usage: set a word redefine via 'tr foo -> bar, get a funny translation via 'tr all your base

if (arg[1] or ""):find("[%-=]>.*;") then
  local n = 0
  local pos = 1
  local str = arg[1]
  for b4, af in str:gmatch("();()") do
    etc.tr(str:sub(pos, b4 - 1), "loop")
    pos = af
    n = n + 1
  end
  etc.tr(str:sub(pos, str:len()), "loop")
  n = n + 1
  print(etc.tr("Done setting " .. n .. " words"))
else
  require "storage"
  local lookup = storage.load(io, "lookup.tr", 2)
  -- print('arg[1]', arg[1])
  local a, c = (arg[1] or ""):match("^ *([^ ]+) *[%-=]> *([^;]-) *$")
  if c then
    require "spam"
    spam.detect(Cache, "tr", 20, 2)
    a = a:lower()
    if a:len() > 16 or c:len() > 16 then
      error(etc.tr("Word too long for " .. a))
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
      print(etc.tr("Done"))
    end
  else
  
    LocalCache.tr = arg[1]:sub(1, 200)
  
    --[[
    local str = (arg[1] or ""):lower()
    local result = ""
    for w in str:gmatch("([%w'%-]+)") do
      if result ~= '' then
        result = result .. " "
      end
      local wnew = lookup[w]
      if wnew then
        result = result .. wnew:lower()
      else
        result = result .. w
      end
    end
    return result
    --]]
    
    return etc.translateWords(arg[1] or "", function(w)
      return lookup[w:lower()]
    end)
    
  end
end