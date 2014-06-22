API "1.1"

local json = require "json"

if Web then
  local event = assert(Web.headers["X-GitHub-Event"], "expected GitHub")
  local f = assert(io.open("github.json", "w"))
  f:write(Web.data)
  f:close()
  
  Output.mode = "irc"
  Output.printType = "irc"
  _clown()
  print("wrote github.json, event: "..event)
  return
end

return "hello, world"
