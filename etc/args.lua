
local s = ""
for i = 1, select('#', ...) do
  if s:len() > 0 then
    s = s .. "|"
  end
  s = s .. "arg" .. i .. "=" .. select(i, ...)
end
return s