local function x(arg)
  local prevAnus = false
  local threshold = 0.9
  return etc.translateWords(arg[1], function(w)
    if prevAnus then
      prevAnus = false
      return
    end
    if math.random() > threshold then
      prevAnus = true
      return "anus"
    end
  end)
end

local y
repeat
  y = x(arg)
until y:find("anus")

return y
