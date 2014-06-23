API "1.1"

local unicode = require "unicode"

return unicode.truncate(arg[1] or '', arg[2] or Output.maxLineLength or 400)
