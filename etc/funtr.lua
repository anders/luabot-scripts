local str = arg[1] or ""

local lol = {}
for w in etc.rdef():gmatch("[%w%-']+") do
  local t = lol[w:len()]
  if not t then
    t = {}
    lol[w:len()] = t
  end
  t[#t + 1] = w
end

return etc.translateWords(str, function(w)
  local t = lol[#w]
  if t and math.random(3) == 2 then
    local wnew = t[math.random(#t)]
    if wnew:upper() ~= wnew then
      wnew = wnew:lower()
    end
    return wnew
  end
end)
