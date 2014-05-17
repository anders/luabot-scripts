local t = {}
local limit = tonumber(arg[1]) or 5000

for uid = 0, math.huge do
  local who = getname(uid)
  if not who then
    break
  end
  local x = worth(who)
  if x and (x >= limit or x <= -limit) then
    if arg[2] or (x > -50000 and who:sub(1, 1) ~= '$') then
      table.insert(t, { who=who, worth = x })
    end
  end
end
table.sort(t, function(x, y)
  return y.worth < x.worth
end)
if Web then
  for i = 1, #t do
    t[i].whograph = t[i].who:gsub("[^%w]", "")
  end
  if Web.GET["config"] then
    -- print("graph_category dbot")
    print("graph_title Worth in CBC")
    print("graph_vlabel CBC")
    print("graph_scale no")
    print("graph_args --base 1000 -l 0")
    for i = 1, #t do
      print(t[i].whograph .. ".label " .. t[i].who)
    end
  else
    for i = 1, #t do
      print(t[i].whograph .. ".value " .. t[i].worth)
    end
  end
else
  for i = 1, #t do
    print(t[i].who, t[i].worth)
  end
end

