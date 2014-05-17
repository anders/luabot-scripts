function hi()
	local function u()
		error('no u!' ); -- ERROR
	end
	return u()
end

x = {}
function x:xxxxx()
	hi()
end

return x:xxxxx()
