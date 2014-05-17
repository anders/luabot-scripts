local k = 'FlappyBird.'..nick
local kr = 'FlappyBird.best.'..nick
local L = LocalCache

if require('spam').detect(Cache, 'flpbrd~1.dat', 5, 2) then error('no') end

L[k] = L[k] or 0
L[kr] = L[kr] or 0

local skill_level = 0.7
if math.random() < skill_level then
  L[k] = L[k] + 1
  print(nick.."'s score: "..L[k])
else
  print(nick.." hit a pipe and died. Score: "..L[k]..", previous record: "..(L[kr] or L[k]))
  if L[k] > (L[kr] or 0) then
    L[kr] = L[k]
  end
  L[k] = 0
end
