-- Usage: 'clench t h a t  s t u f f
local t = {}
local i = 0
for c in etc.codepoints(arg[1]) do
  if i % 2 == 0 then t[#t + 1] = c end
  i = i + 1
end
return table.concat(t, "")
