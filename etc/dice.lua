local num = arg[1] or "1"
if num == "rigged" then
   print("no u")
   return
end
local out = ""
for i = 1, tonumber(num) do
  local dice = {'2680', '2681', '2682', '2683', '2684', '2685'}
  out = out .. etc.U(dice[math.random(1, #dice)])
end
print(out)
