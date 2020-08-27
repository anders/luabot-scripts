API "1.1"

local anus = ... or '[[abc]] def'

local source, input = anus:match("%[%[([^\]]+)%]%]%s?(.+)")
assert(source, 'need source (wrap with [[ xx ]])')
assert(input, 'need input (just input something)')

local tmpl = [[
local s = ... ;
return $
]]


local fn = assert(loadstring(tmpl:gsub("%$", source)))

local pwnt = fn(input)
return pwnt


