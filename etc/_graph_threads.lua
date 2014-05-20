if Editor then return end
local t = {}
t.title = "Threads created by " .. bot
t.vlabel = "Threads"
t.lowerLimit = 0
local threads = Cache.graphThreads or 0
if (Cache.graphThreads_t or 0) < os.time() - 60 * 10 then
  _clown()
  print("Warning: _graph_threads using stale data")
  threads = 0
end
t.data = { threads = threads }
return t
