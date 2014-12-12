API "1.1"

local json = require "json"

-- http://pokeapi.co/api/v1/pokemon/151/
-- http://pokeapi.co/api/v1/pokemon/mew/

local query = assert(arg[1], "need pokemon ID or name")

local function fmt_types(t)
  local tmp = {}
  for k, v in ipairs(t) do
    tmp[#tmp + 1] = v.name:sub(1, 1):upper() .. v.name:sub(2)
  end
  return table.concat(tmp, ", ")
end

local resp = assert(httpGet("http://pokeapi.co/api/v1/pokemon/"..query.."/"))
local d = json.decode(resp)

print(("#%03d %s (%s)"):format(d.national_id, d.name, fmt_types(d.types)))
