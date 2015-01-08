local cocks = {}
for k, nick in pairs(nicklist()) do
  cocks[#cocks + 1] = {nick, etc.cock(nick)}
  cocks[#cocks][3] = #cocks[#cocks][2]
end

table.sort(cocks, function(a, b) return a[3] > b[3] end)

local t = {}
for i, cock in ipairs(cocks) do
  t[#t + 1] = ("\2%s:\2 %s"):format(cock[1], cock[2])
end

return etc.nonickalert(table.concat(t, ", "))
