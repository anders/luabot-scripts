API "1.1"

local needle, haystack = ...
assert(needle and haystack, "need needle, haystack")

local n = 0
local i = 1
while true do
  local newi = haystack:find(needle, i, true)
  if not newi then
    break
  end
  n = n + 1
  i = newi + #needle
end
return n
