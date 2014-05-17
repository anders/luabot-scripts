local a = (arg[1] or ""):gsub("(%w)(%w%w+)(%w)", function(x, y, z)
  return x .. etc.randomize(y) .. z
end)
return a
