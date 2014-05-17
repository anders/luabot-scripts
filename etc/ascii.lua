local s = arg[1] or ""
for i = 1, s:len() do
  local b = s:sub(i, i):byte()
  if b >= 0x80 then
    error("Not ASCII")
  end
end
return s:byte(1, s:len())
