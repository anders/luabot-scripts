if Editor then return end
local LOG = plugin.log(_funcname);
local t = {}
t.title = "Threads created by " .. bot
t.vlabel = "Threads/minute"
t.lowerLimit = 0
local threads5 = Cache.graphThreads or 0
if (Cache.graphThreads_t or 0) < os.time() - 60 * 10 then
  -- _clown()
  LOG.warn("Warning: _graph_threads using stale data")
  threads5 = 0
end
t.data = { threads = threads5 / 5 }
return t
