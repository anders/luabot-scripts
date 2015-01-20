API "1.1"

local s = arg[1] or ''
local a, b = s:match("([^ ,:%.]+)(.*)")
if a == 'hate' or a == 'love' or a == 'like' or a == 'dislike' or a == 'suck' or a == 'think' then
  s = a .. 's' .. b
end

return etc.he(s)
