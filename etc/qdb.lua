local s
local i = 1
if not Cache.qdb or not Cache.qdb_pos or Cache.qdb == 0 then
  s = assert(httpGet("http://qdb.us/random"))
  local x = s:find("<[bB][oO][dD][yY]")
  if x then
    s = s:sub(x + 5 + 1)
  end
  local f = assert(io.open("qdb.cache", 'w'))
  -- f:write(s)
  s = s:gsub("[\r\n]+", " ")
  f:write(s:sub(1, 1024 * 12))
  f:close()
  Cache.qdb = 3
else
  Cache.qdb = Cache.qdb - 1
  local f = assert(io.open("qdb.cache"))
  -- s = f:read("*a")
  s = f:read()
  -- s = f:read(1024 * 12)
  f:close()
  i = Cache.qdb_pos or math.random(1, s:len())
end
while true do
  local q, qpos = s:match("<span class=qt[^>]+>(.-)</span>()", i)
  if not q then
    error("Quote not found")
  end
  if q:len() <= 350 then
    Cache.qdb_pos = qpos
    local s = q:gsub("<br ?/?>", " &nbsp; ")
    s = html2text(s)
    -- return s
    print(s)
    return
  end
  i = qpos
end