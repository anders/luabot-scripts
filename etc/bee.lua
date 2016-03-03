API "1.1"

return etc.translateWords(arg[1], function(w)
  if #w < 2 then
    return "bz"
  else
    return "b"..("z"):rep(#w-1)
  end
end)
