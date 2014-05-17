Output.maxLines = 1
return etc.less(etc.getOutput(function()
  local hist = {}
  for i = 1, math.huge do
    local h = { _getHistory(i) }
    if not h[1] then
      break
    end
    hist[i] = h
  end
  
  for i = #hist, 1, -1 do
    local h = hist[i]
    print(("[%s] <%s> %s"):format(os.date("!%c", h[3]), h[2], h[1]))
  end
end))
