API "1.1"

-- TODO: don't hard code
local corrections = {
  ["ttha"] = "ಠ",
  ["ass"] = "butt",
}

local msg = (Event and Event.msg) or LocalCache.lastmsg
local orig = msg

for k, v in pairs(corrections) do
  msg = msg:gsub(k, "\31"..v.."\31")
end

if msg ~= orig then
  print("<"..nick.."> "..msg)
end
