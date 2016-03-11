API "1.1"
-- Usage: 'something_bad|'pg cleans up the language to be PG.

local arg = arg or{...}
local str = arg[1]
local goodwords = arg[2] or {
  "friend", "puppy", "kitten", "movie",
  "princess", "song", "toy", "game",
  "fun", "happy", "yay", "hooray",
}
local slang = arg[3] or etc.xxxslang()

local slangmap = {}
for i = 1, #slang do
  slangmap[slang[i]] = pickone(goodwords)
end

function getclean(w)
  local wl = w:lower()
  if slangmap[wl] or wl:find("\102\117\99\107", 1, true) then
    local cleanw = slangmap[wl]
    if not cleanw then
      cleanw = pickone(goodwords)
      slangmap[wl] = cleanw
    end
    return cleanw
  end
  return w
end

return etc.translateWords(str, function(w)
  return getclean(w)
end)
