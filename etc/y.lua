return (arg[1]:gsub('%a+', function(w)
  local c = w:sub(-1, -1):lower()
  local isupper = w:upper() == w
  if c == 'y' or c == 'o' or c == 'u' then
    w = w
  elseif c == 'l' then
    w = w..'ly'
  elseif c == 'e' then
    w = w:sub(1, -2)..'y'
  else
    w = w..'y'
  end
  return isupper and w:upper() or w
end))
