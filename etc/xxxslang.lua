API "1.1"

local slangstr = assert(etc.code(etc.xxx):match("slang = {(.-)}"), "can't find xxx slang")
local getslang = assert(guestloadstring("return {" .. slangstr .. "}"))
local slang = getslang()
return slang
