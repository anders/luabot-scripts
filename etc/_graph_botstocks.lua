local limit = tonumber(arg[1]) or 5000
local t = {}
t.title = "Values of Botstocks"
t.vlabel = "Value in CBC"
t.lowerLimit = 0
t.data = {}
for name, value in pairs(botstockValues()) do
  t.data[name] = value
end
return t
