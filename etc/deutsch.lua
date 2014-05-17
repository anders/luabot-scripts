angriness = 0.4


return (arg[1]:gsub(" ", function (x)
  return math.random() < angriness and (" " .. etc.getOutput(etc.wm4gen) .. " ") or " "
end)) or ""