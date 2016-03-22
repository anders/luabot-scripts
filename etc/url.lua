API "1.1"
-- Usage: 'url lol

local arg = arg or {...}
local s = (arg[1] or nick or bot or "u"):gsub("[^a-zA-Z0-9]", "")

local sub = "www"
if math.random() < 0.5 then
  -- sub = etc.rdef():match("[a-zA-Z]+") or "www"
  sub = etc.someword()
end

local pfx = "thereal"
if math.random() < 0.75 then
  -- sub = etc.rdef():match("[a-zA-Z]+") or "www"
  pfx = etc.someword()
end
if math.random() < 0.5 then
  pfx = pfx .. "-"
end

return "http://" .. sub .. "." .. pfx .. s:gsub("[^a-zA-Z0-9]", "") .. "." .. etc.tld() .. "/" .. (math.random() < 0.5 and etc.someword() or "")
