s='yes\nno\nmaybe yes\nno'
if arg[1] and #arg[1]>1 then
  t={}
  for w in s:gmatch("[^\n]+") do print("<"..arg[1].."> "..w) end
else
  return s
end
