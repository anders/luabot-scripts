API "1.1"

local s = etc.trunc(arg[1] or ''):gsub("[,;%.!%?]", "")
local prob = math.floor(#s / 12)
return etc.translateWords(s, function(w)
  if math.random(prob) == 1 then
    return w .. ","
  end
end)
