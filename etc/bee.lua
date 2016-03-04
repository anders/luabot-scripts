API "1.1"

return etc.translateWords(arg[1], function(w)
  -- used to return "bz", but that looks stupid with results like "BZ"
  if #w < 2 then return end

  -- skip numbers
  if w:match("[%d%.]+") then return end

  -- ouch
  if math.random() < 0.1 then return "*sting*" end
  
  return "b"..("z"):rep(#w-1)
end)
