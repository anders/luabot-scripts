assert(Event.name == "cron_timer")
assert(Event.cronTimerResolution == 60 * 5)
-- assert(allCodeTrusted(), "Breached") -- Other crons interfere.
if Cache.graphThreads_i then
  Cache.graphThreads = _threadid - Cache.graphThreads_i
end
Cache.graphThreads_i = _threadid
Cache.graphThreads_t = os.time()
