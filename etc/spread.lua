-- Usage: 'spread that stuff
-- return (arg[1] or ''):gsub(".", "%1" .. (arg[2] or ' ')) or ''
local t = {}
for c in etc.codepoints(arg[1]) do
  t[#t + 1] = c
end
return table.concat(t, arg[2] or ' ')
