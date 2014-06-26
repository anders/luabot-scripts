local s_senpai = 0.65

return (arg[1]:gsub("(%a[%w%p]+)", function(w)
  if math.random() >= s_senpai then
    return (w:sub(1, 1).."-"):rep(math.random(1, 3))..w
  else
    return w
  end
end))
