local apikeyraw = {
  tostring(seed),
  math.random(),
  os.time(),
  tostring(_G),
}
  
for i = 1, select('#', ...) do
  local x = select(i, ...)
  apikeyraw[#apikeyraw + 1] = tostring(x)
end

-- directprint(table.concat(apikeyraw, '\1'))
return etc.md5(table.concat(apikeyraw, '\1'))
