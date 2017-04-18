API "1.1"

local Date = require "date"

local arg1 = arg[1] or "2017-12-25"

local date1 = Date()
local date2 = Date(arg1)

return etc.duration((date2-date1):spanseconds())
