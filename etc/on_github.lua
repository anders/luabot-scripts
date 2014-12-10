API "1.1"

local json = require "json"

if Web then
  local event = assert(Web.headers["X-GitHub-Event"], "expected GitHub")
  local f = assert(io.open("github.json", "w"))
  f:write(Web.data)
  f:close()
  
  chan = "#clowngames"
  
  Output.mode = "irc"
  Output.printType = "irc"
  _clown()
  -- sendNotice(chan, "wrote github.json, event: "..event)
  return
end

local event = "push" or arg[1]

local f = assert(io.open("github.json", "r"))
local data = assert(f:read("*a"))
data = assert(json.decode(data))

-- etc.output(data)

-- Notice(GitHub): [luabot-scripts] anders pushed 1 new commit to master: http://git.io/WMzlow
-- Notice(GitHub): luabot-scripts/master eb66efa L. Bot: Sync....


sendNotice(chan, ("[%s] %s pushed %d new commit(s) to %s: %s"):format(
  data.repository.name,
  data.pusher.name,
  #data.commits,
  data.ref,
  data.head_commit.url))
for k, v in ipairs(data.commits) do
  sendNotice(chan, ("%s/%s %s %s: %s"):format(
    data.repository.name, data.ref,
    v.id:sub(1, 7),
    v.author.name,
    v.message:gsub("\n", " | ")
  ))
end
