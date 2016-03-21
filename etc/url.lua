API "1.1"
-- Usage: 'url lol

local arg = arg or {...}
local s = arg[1] or nick or bot or "u"

local sub = "www"
if math.random() < 0.5 then
  sub = etc.rdef():match("[a-zA-Z]+") or "www"
end

return "http://" .. sub .. "." .. s:gsub("[^a-zA-Z0-9]", "") .. "." .. etc.tld() .. "/" .. (math.random() < 0.5 and etc.rdef():match("[a-zA-Z]+") or "")
