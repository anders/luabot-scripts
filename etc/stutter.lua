local s_senpai = 0.65
local text, always_stutter = ...
local rand = math.random

return (arg[1]:gsub("(%a[%w%p]+)", function(w)
  if always_stutter or rand() >= s_senpai then
    return (w:sub(1, 1).."-"):rep(rand(1, 2) + rand(0, 1))..w
  else
    return w
  end
end))
