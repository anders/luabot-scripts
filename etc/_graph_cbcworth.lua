local limit = tonumber(arg[1]) or 5000
local t = {}
t.title = "Worth in CBC"
t.vlabel = "CBC"
t.lowerLimit = 0
t.data = {}
for uid = 0, math.huge do
  local who = getname(uid)
  if not who then
    break
  end
  local x = worth(who)
  if x and (x >= limit or x <= -limit) then
    if arg[2] or (x > -50000 and who:sub(1, 1) ~= '$') then
      t.data[who] = x
    end
  end
end
return t
