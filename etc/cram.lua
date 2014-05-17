-- Usage: 'cram some shit into one line.

local str = arg[1] or ''
local delim = " "

return str:gsub("[\r\n]+", delim) or ''
