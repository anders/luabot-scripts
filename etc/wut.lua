local s = ""

s = "" .. select('#', ...) .. " args, piped pos=" .. tostring(Input.piped)

for i = 1, select('#', ...) do
  if s:len() > 0 then
    s = s .. ", "
  end
  s = s .. tostring(select(i, ...))
end

return s
