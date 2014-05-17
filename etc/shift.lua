-- Shift the values in an array.
local t = arg[1]
local shiftby = arg[2] or 1

assert(type(t) == "table", "Need a table")

local tlen = #t
for i = 1, tlen - shiftby do
  t[i] = t[i + shiftby]
  -- t[i + shiftby] = nil
end
for i = tlen - shiftby + 1, tlen do
  t[i] = nil
end

return t
