local threshold = 0.9
return etc.translateWords(arg[1], function(w)
  if math.random() > threshold then
    return "anus"
  end
end)
