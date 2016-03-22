API "1.1"


local function w1()
  local r = math.random()
  
  if r < 0.25 then
    return etc.rdef():match("[a-zA-Z]+")
  elseif r < 0.5 then
    return etc.funword()
  elseif r < 0.75 then
    return etc.badword()
  else
    return pickone(etc.xxxslang())
  end
end

local function w2()
  local w = w1()
  local r = math.random()
  if r < 0.1 then
    w = etc.er(w)
  end
  return w
end

return w2()
