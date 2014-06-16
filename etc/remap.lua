API "1.1"

-- Use etc.totable(str) to convert strings to tables.
assert(type(arg[1]) == 'string' and type(arg[2]) == 'table' and type(arg[3]) == 'table',
  'Need string and 2 tables')

local s, t1, t2 = ...

local tr = {}
for ch in etc.codepoints(s) do
  local found = false
  for ti = 1, math.min(#t1, #t2) do
    if ch == t1[ti] then
      found = true
      tr[#tr + 1] = t2[ti]
      break
    end
  end
  if not found then
    tr[#tr + 1] = ch
  end
end
return table.concat(tr)
