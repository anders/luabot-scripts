local s = pickone{"yes", "yes!", "ok fine", "k", "of course", "certainly", "amen", "without fail", "very well", "make it so"}
if arg[1] then
  s = s .. " " .. arg[1]
end
return s
