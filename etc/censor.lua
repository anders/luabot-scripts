API "1.1"

return arg[1]:gsub("([aeiouAEIOU]+)", function (c) return math.random() <= 0.5 and string.rep("*", #c) or c end) or ""
