API "1.1"

-- byte limit
local LIMIT = 220

local unicode = require "unicode"

return unicode.truncate(arg[1], LIMIT)
