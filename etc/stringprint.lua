-- Usage: etc.stringprint(...) - returns a string with all parameters concatenated into one string, delimited by spaces.

local t = {}
for i = 1, select('#', ...) do
  t[#t + 1] = tostring(select(i, ...))
end
return table.concat(t, " ")
