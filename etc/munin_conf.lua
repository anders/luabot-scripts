return {
  plugins = {
    "cbcworth",
    "botstocks",
    "memusage",
    "threads",
    "cbcvalue", -- make sure cron_cbcvalue caches the value.
    "bday",
    -- "dbotusers", -- breaks munin for unknown reason.
  };
}
