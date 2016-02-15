return boturl .. "u/%24guest/debuglog/"
  .. assert(LocalCache.lastdebuglogid, "No log found") .. ".log"
