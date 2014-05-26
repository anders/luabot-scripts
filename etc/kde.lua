-- There must be a nicer way to do this...
-- pseudo code:
-- for each word that does not begin with `k' or `ch' (any case):
--   replace initial c with k, initial C with K
--   otherwise just prepend k/K based on first letter case
return (arg[1]:gsub("%a+", function(w)
  if w:sub(1, 2):lower() ~= "ch" then
    if w:sub(1, 1) == "c" then return "k"..w:sub(2)
    elseif w:sub(1, 1) == "C" then return "K"..w:sub(2) end
    if w:sub(1, 1):lower() ~= "k" then
      if w:sub(1, 1):lower() == w:sub(1, 1) then return "k"..w
      else return "K"..w end
    else
      return w
    end
  end
end))