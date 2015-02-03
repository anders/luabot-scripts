local s_senpai = 0.65
local text = ...
local rand = math.random

return (arg[1]:gsub("(%a[%w%p]+)", function(w)
  if rand() >= s_senpai then
    --return (w:sub(1, 1).."-"):rep(rand(1, 2) + rand(0, 1))..w
    local c = w:sub(1, 1)
    return c:rep(rand(1, rand() >= 0.7 and 3 or 1)).."-"..(c.."-"):rep(rand(0, 2))..w
  else
    return w
  end
end))
