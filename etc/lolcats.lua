local x, xerr = etc.getOutput(etc.rand, "'funny")
if not x then
  return x, xerr
end
return etc.cats(x)
