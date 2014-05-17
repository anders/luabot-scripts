local x = (arg[1] or ""):gsub("%w+", function(w)
  if math.random(2) == 1 then
    return etc.flip(w)
  end
  return w
end)
return x