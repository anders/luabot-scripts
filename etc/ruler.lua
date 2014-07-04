API "1.1"

local A, B = arg[1]:match("(%w+) (%w+)")
if not A then A = arg[1] end
B = B and #B > 0 and B or nick

a, b = etc.cock(A), etc.cock(B)

if #a > #b then
  print(A.." is "..#a-#b.." cm bigger")
elseif #b > #a then
  print(B.." is "..#b-#a.." cm bigger")
else
  print("you're equally big ;-)")
end
