if Editor then return end

local lastcron = Cache.lastcron
Cache.lastcron = os.time()
-- return etc.on_cron_timer_impl(lastcron)

if Cache.last_cron_func then
  _clown()
  print("on_cron_timer found a misbehaving cron function: etc." .. Cache.last_cron_func)
end

local last = ...
local t = etc.findFunc("^cron_")
assert(type(t) == 'table')
for _, k in ipairs(t) do
  local v = etc[k]
  Cache.last_cron_func = k -- in case of OOM or script timeout
  pcall(v, last)
end

Cache.last_cron_func = nil
