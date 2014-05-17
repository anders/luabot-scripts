local letter = (arg[1] or ''):match('%w'):lower()

if not letter or letter == '' then
  error("What letter!")
end

require "storage"
local lookups = storage.load(io, "acro")

local pool = lookups[letter .. "__"]
local npool = storage.length(pool or {})
if not pool or npool == 0 then
  return "", "Nothing"
end
return etc.t(pool), ""
-- return table.concat(pool, " ", 1, npool), "" -- concat doesn't support __index
