--[[
return "Balance: about $" ..
  (cash('$dealer')
  + cash('$broker')
  + cash('byte[]')
  + cash('wm4')
  + cash('anders')
  )
  .. " (botcoins added for $dealer $broker and top 3 users)" 
--]]

local tot = cash('$dealer') + cash('$broker')
for i = 0, 10000000 do
  local n = getname(i)
  if not n then
    break
  end
  if n ~= "$dealer" and n ~= "$broker" then
    tot = tot + cash(n)
  end
end
return "Balance: about $" .. tot .. " (botcoins added for $dealer $broker and everyone)"
