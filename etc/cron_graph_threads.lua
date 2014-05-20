assert(Event.name == "cron_timer")
assert(Event.cronTimerResolution == 60 * 5)
if not allCodeTrusted() then
  Cache.lastfail = _funcname .. " not trusted due to " .. whyNotCodeTrusted()
end
assert(allCodeTrusted(), "Breached")
Cache.graphThreads = math.max(_threadid - (Cache.graphThreads_i or 0), 0)
Cache.graphThreads_i = _threadid
Cache.graphThreads_t = os.time()
