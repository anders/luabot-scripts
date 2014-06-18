API "1.1"

local nhistory = (function()
  local i = 1
  while true do
    if not _getHistory(i) then
      break
    end
    i = i + 1
  end
  return i
end)()

return _getHistory(math.random(nhistory))
