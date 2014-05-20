assert(Event.name == "cron_timer")
assert(Event.cronTimerResolution == 60 * 5)
if not allCodeTrusted() then
  Cache.lastfail = _funcname .. " not trusted due to " .. whyNotCodeTrusted()
end
assert(allCodeTrusted(), "Breached")
if Cache.graphThreads_i then
  Cache.graphThreads = _threadid - Cache.graphThreads_i
end
Cache.graphThreads_i = _threadid
Cache.graphThreads_t = os.time()
