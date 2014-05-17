local s, find, rep = arg[1], arg[2], arg[3]

	local findlen = string.len(find)
	local replen = string.len(rep)
	local i = 1
	while true do
		i = string.find(s, find, i, true)
		if not i then
			break
		end
		s = string.sub(s, 1, i - 1) .. rep .. string.sub(s, i + findlen)
		i = i + replen
	end
	return s

--[[
assert(replace("foo", "l", "o") == "foo")
assert(replace("all your base", "l", "o") == "aoo your base", replace("all your base", "l", "o"))
assert(replace("all your base", "base", "BASE") == "all your BASE", replace("all your base", "base", "BASE"))
--]]