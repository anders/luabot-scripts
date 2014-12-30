assert(Event.name == "cron_timer")
assert(Event.cronTimerResolution == 60 * 5)
if not allCodeTrusted() then
  Cache.lastfail = _funcname .. " not trusted due to " .. whyNotCodeTrusted()
end
assert(allCodeTrusted(), "Breached")

-- This is needed because the cbcvalue graph can't do it.
----------- DISABLED: etc.cbcvalue('-cache')
