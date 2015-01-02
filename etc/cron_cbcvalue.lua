assert(Event.name == "cron_timer")
assert(Event.cronTimerResolution == 60 * 5)
-- assert(allCodeTrusted(), "Breached") -- Other crons interfere.

-- This is needed because the cbcvalue graph can't do it.
etc.cbcvalue('-cache')
