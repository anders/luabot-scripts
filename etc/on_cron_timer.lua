local lastcron = Cache.lastcron
Cache.lastcron = os.time()
return etc.on_cron_timer_impl(lastcron)
