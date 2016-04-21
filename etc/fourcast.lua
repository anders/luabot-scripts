API "1.1"
-- Usage: same as forecast, but removes the header so that 4 days can be seen.

return etc.cmd(([['forecast %s |'grep -v Forecast]]):format(arg[1] or ''))
