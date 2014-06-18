-- Usage: 'fml - F my life.

local s
local i = 1
if not Cache.fml or not Cache.fml_pos or Cache.fml == 0 then
  s = assert(httpGet("http://www.fmylife.com/random"))
  local x = s:find("<div class=\"post article\"")
  if x then
    s = s:sub(x)
  end
  local f = assert(io.open("fml.cache", 'w'))
  -- f:write(s)
  s = s:gsub("[\r\n]+", " ")
  f:write(s:sub(1, 1024 * 12))
  f:close()
  Cache.fml = 3
else
  Cache.fml = Cache.fml - 1
  local f = assert(io.open("fml.cache"))
  -- s = f:read("*a")
  s = f:read()
  -- s = f:read(1024 * 12)
  f:close()
  i = Cache.fml_pos or math.random(1, s:len())
end
while true do
  local q, qpos = s:match("<div class=\"post article\".-<p>(.-)</p>()", i)
  if not q then
    Cache.fml = 0
    -- error("Quote not found")
    return etc.fml(...)
  end
  if q:len() <= 350 then
    Cache.fml_pos = qpos
    local s = q:gsub("<br ?/?>", " &nbsp; ")
    s = html2text(s)
    -- return s
    print(s)
    return
  end
  i = qpos
end
