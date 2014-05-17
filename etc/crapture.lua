-- Usage: 'crapture - like 'capture but for crap!
local x = etc.getOutput(etc.capture)
if not x then
  x = etc.getOutput(etc.rand, "'ud")
  if not x then
    x = "wtf is wrong with you"
  end
end
x = x:sub(1, 512)
x = etc.funny(x)
print(x)
