local x, xerr = etc.getOutput(etc.forecast, ...)
if not x then
  return x, xerr
end
return etc.xxx(x)
