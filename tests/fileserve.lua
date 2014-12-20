API "1.1"

local fs = io.fs
assert(account == 1)

local method, action = (arg[1] or 'GET list'):match("^([^ ]+) ([^ ]+)$")

return etc.on_fileserve(nick, fs, method, action)
