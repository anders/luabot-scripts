-- *** CONSIDER USING STORAGE! *** plugin.storage

-- Lua data serializer.
-- Note: this serializer gets pretty expensive when >50 items.
-- plugin.storage is designed to be more scalable.

--[[
require "serializer"
local obj = serializer.load(io, "my.file")
obj.foo = "bar"
serializer.save(io, "my.file", obj)
--]]

local _M = {}


function _M.load(io, name)
 if io.fs then
   io = io.fs
 end
 io._fast = true
 local f, ferr = io.open(name, 'r')
 if not f then
   -- If it fails to open it could be that it doesn't exist yet,
   -- or another problem occured.
   if io.rename then
     io.rename(name, name .. ".old")
   end
   return {}, ferr
 end
 local t = {}
 table.insert(t, "return { ")
 while true do
   local x = f:read(1024 * 4)
   if not x then
     break
   end
   table.insert(t, x)
 end
 f:close()
 table.insert(t, " }")
 local s = table.concat(t)
 local fn, fnerr = safeloadstring(s, "serializer.load:"..name)
 if not fn then
   -- if not silentFail then
     error(fnerr)
   -- end
   return nil, fnerr
 end
 return fn(), true
end


local entry -- forward decl
local entrytable


function _M.save(io, name, obj)
  if io.fs then
   io = io.fs
  end
  io._fast = true
  local tmpname = name
  if io.rename and io.remove then
     tmpname = name .. ".new"
  end
  local f, ferr = io.open(tmpname, 'wb')
  if not f then
    -- if not silentFail then
     error(ferr)
    -- end
    return nil, ferr
  end
  for k, v in pairs(obj) do
     entry(k, v, 0, f)
  end
  f:close()
  if io.rename and io.remove then
     io.remove(name)
     assert(io.rename(tmpname, name))
  end
  return true
end

local function entrytable(k, v, level, file)
	local ktype = type(k)
	file:write(string.rep("\t", level))
	if ktype == "number" then
		file:write("[", k, "]={\n")
	elseif ktype == "string" then
		file:write(string.format("[%q]={\n", k))
	end
	for k2, v2 in pairs(v) do
		entry(k2, v2, level + 1, file)
	end
	file:write(string.rep("\t", level))
	file:write("},\n")
end

function entry(k, v, level, file)
	local ktype, vtype = type(k), type(v)
	if vtype == "table" then
		entrytable(k, v, level, file)
	else
		file:write(string.rep("\t", level))
		if ktype == "number" then
			if vtype == "number" then
				file:write("[", k, "]=", v, ",\n")
			elseif vtype == "string" then
				file:write(string.format("[%s]=%q,\n", k, v))
			elseif vtype == "boolean" then
				file:write(string.format("[%s]=%s,\n", k, tostring(v)))
			end
		elseif ktype == "string" then
			if k:find("^%a[%a%d_]*$") then
				if vtype == "number" then
					file:write(k, "=", v, ",\n")
				elseif vtype == "string" then
					file:write(string.format("%s=%q,\n", k, v))
				elseif vtype == "boolean" then
					file:write(string.format("%s=%s,\n", k, tostring(v)))
				end
			else
				if vtype == "number" then
					file:write(string.format("[%q]=%s,\n", k, v))
				elseif vtype == "string" then
					file:write(string.format("[%q]=%q,\n", k, v))
				elseif vtype == "boolean" then
					file:write(string.format("[%q]=%s,\n", k, tostring(v)))
				end
			end
		end
	end
end

return _M
