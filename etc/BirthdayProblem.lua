API "1.1"

local birthdays = {}
local numDays = 365

local numSamples = tonumber(arg[1]) or 30

local numDupes = 0
for i = 1, numSamples do
  local bday = math.random(1, numDays)
  local x = birthdays[bday] or 0
  x = x + 1
  if x == 2 then
    numDupes = numDupes + 2
  elseif x > 2 then
    numDupes = numDupes + 1
  end
  birthdays[bday] = x
end
print("Out of " .. numSamples .. " people, " .. numDupes .. " had a duplicate " .. (arg[2] or "birthday"))
return numDupes, numSamples
