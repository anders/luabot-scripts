API "1.1"

if type(arg[1]) ~= "string" then
  return "butt?"
else
  return etc.translateWords(arg[1], function(w)
    local wl = w:lower()
    local wt = etc.getWordType(w)
    if wt == 'noun' then
      return "butt"
    --elseif wt == 'verb' then
    --  return "butting"
    end
  end)
end
