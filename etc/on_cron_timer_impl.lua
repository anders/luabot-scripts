local last = ...
local t = etc.find('"cron_*"', true) -- fuck you byte[]
assert(type(t) == 'table')
for _, k in ipairs(t) do
  local v = etc[k]
  Cache.last_cron_func = k -- in case of OOM or script timeout
  pcall(v, last)
end