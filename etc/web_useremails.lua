assert(Web, "should be run as a Web page ok")
local json = require "json"

local ret = {}

for k, v in ipairs(os.list("uvars")) do
  local user = v:match("uvars/([^.]+).json")
  local name = etc.get("github.name", user)
  local email = etc.get("github.email", user)
  
  local ok = true
  if name and not name:match("^[%w%-_%[%] ]+$") then ok = false end
  if email and not email:match("^[%w%.@%-_ ]+$") then ok = false end
  
  if ok and name or email then
    ret[user] = {name = name, email = email}
  end
end

Web.header("Content-Type: application/json")
Web.write(json.encode(ret))
