local junk = {
  'in #dbot U can do anything.. butts',
  'butts are the best',
  'man i could go for some bUtts right about now',
  'dayum boi i want some butts',
  'craving for butts',
  'butts for the win',
  'over 9000 butts',
  'butts, do i need to say anything else?'
}

while #junk > 0 do
  local n = math.random(1, #junk)
  local s = junk[n]
  table.remove(junk, n)
  print(s)
end
