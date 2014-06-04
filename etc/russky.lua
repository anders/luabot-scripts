return etc.translateWords(arg[1], 
function(w) w=w:lower() if w == 'the' or w == 'an' or w == 'a' then return '' end end
  ):gsub(" +", " "):gsub("^ +", "") or ""
