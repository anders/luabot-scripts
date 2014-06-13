-- Usage: 'cram some shit into one line.

local str = arg[1] or ''
local delim = arg[2] or " "

return str:gsub("[\r\n]+", delim) or ''
