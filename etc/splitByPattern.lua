API "1.1"

local what, pat, t = ...
t = t or {}
local pos = 1
while true do
  local newpos, endpos = what:find(pat, pos)
  if not newpos then
    t[#t + 1] = what:sub(pos)
    break
  end
  t[#t + 1] = what:sub(pos, newpos - 1)
  pos = endpos + 1
end
return t
