local s = pickone{"maybe", "if the price is high enough", "on a good day", "as it may be", "weather permitting", "perchance", "conceivably"}
if arg[1] then
  s = s .. " " .. arg[1]
end
return s
