-- Usage: lua pattern, finds last matching line

local query = arg[1]

local history = function(n)
  local msg, user, ts = _getHistory(n)
  if user and msg then
    if not nonick then
      return msg
    else
      return msg
    end
  end
end

local n = 1
while true do
  local s = history(n)
  if query and not s then
    return 'No matching line.'
  elseif not query or (query and s:find(query)) then
    return s
  end
  n = n + 1
end
