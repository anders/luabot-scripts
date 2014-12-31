return {
  plugins = {
    "cbcworth",
    "botstocks",
    "memusage",
    "threads",
    "cbcvalue", -- make sure cron_cbcvalue caches the value.
    -- "dbotusers", -- breaks munin for unknown reason.
  };
}
