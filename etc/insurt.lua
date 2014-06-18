local x, xerr = etc.getOutput(etc.insult, ...)
if not x then
  return x, xerr
end
return etc.lacist(x)
