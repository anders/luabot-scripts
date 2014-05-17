if arg[1] ~= "heads" and arg[1] ~= "tails" then
  assert(false, "heads or tails?")
end

local sides = { "heads", "tails" }
local result = sides[math.random(#sides)]
if result == arg[1] then
  ucashGive(5, nick)
  print(result .. " - you win " .. ucashInfo() .. "5")
else
  ucashGive(-5, nick)
  print(result .. " - you lose " .. ucashInfo() .. "5")
end
