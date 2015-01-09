API "1.1"

-- Usage: etc.dateToTime(year-month-day) - timestamp of the start of the provided day

local y, m, d = assert(arg[1]):match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
if y then
  return os.time{year=y, month=m, day=d, hour=0, min=0, sec=0}
end
