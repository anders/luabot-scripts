baguette = 0.4


return (arg[1]:gsub(" ", function (x)
  return math.random() < baguette and " le " or " "
end) .. " xD"):gsub("FML", "VDM") or ""