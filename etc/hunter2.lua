API "1.1"
-- Usage: pipe text into this function for a ******* result.

return etc.translateWords(arg[1] or '', function(w)
  if math.random(4) == 1 then
    if math.random(2) == 1 then
      if math.random(2) == 1 then
        return "hunter2-ing"
      else
        return "hunter2"
      end
    else
      if math.random(2) == 1 then
        return "password is *******"
      else
        return "*******"
      end
    end
  end
end)
