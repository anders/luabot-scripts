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

local msg, nick, time = _getHistory(math.random(nhistory))
if not msg then
  return nil, nick
end
return etc.duration(os.time() - time, 1) .. " ago <" .. nick .. "> " .. msg
