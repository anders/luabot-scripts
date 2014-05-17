local function to_s(v)
  if type(v) == 'string' then
    return ('%q'):format(v)
  else
    return tostring(v)
  end
end

local function table_print(t, indent)
	local indent = indent or 0
	for k, v in pairs(t) do
		if type(v) == 'table' then
			print(('  '):rep(indent)..to_s(k)..' = {')
			table_print(v, indent + 1)
			print(('  '):rep(indent)..'}')
		else
			print(('  '):rep(indent)..to_s(k)..' = '..to_s(v))
		end
	end
end

assert(type(arg[1]) == 'table', 'expected table')

return table_print(arg[1], arg[2])