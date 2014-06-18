local x, xerr = etc.getOutput(etc.flappybird, ...)
if not x then
  return x, xerr
end
return etc.o(x)
