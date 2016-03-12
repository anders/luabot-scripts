API "1.1"
-- Usage: 'lastby <nick> gets the last message by that nick

local by = ...
assert(by, "Last by which nick?")

for i = 1, 100 do
  local msg, nick, time = _getHistory(i)
  if not nick then
    break
  end
  if nick == by then
    return msg
  end
end
