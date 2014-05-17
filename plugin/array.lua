-- 
-- Array helper
-- 
-- If you want some function to be added, msg robik on IRC.
local _A = {}

--
-- Slices table
--
-- @param a Source table
-- @param s Start index
-- @param c Number of elements to slice
function _A.slice(a, s, c)
  assert(type(a) == "table",  "First parameter must be a table")
  assert(type(s) == "number", "Second parameter must be a number")
  
  local res = {}
  
  if s < 0 then
    s = #a - math.abs(s)
  end
  
  if c == nil then
    c = #a-s
  end
    
  for i = s, s+c-1 do
    res[#res + 1] = a[i+1]
  end
  
  return res
end


--
-- Merges tables values
--
-- @param ... Tables to merge
function _A.merge(...)
  local res = {}
  local args = {...}
  
  for k,t in ipairs(args) do
    assert(type(t) == "table", "Specified arguments must be tables")
    
    for k, v in ipairs(t) do
      res[#res +1] = v
    end
  end
  
  return res
end


--
-- Returns values of table
-- @param table Soruce table
--
function _A.values(table)
  assert(type(a) == "table",  "First parameter must be a table")
  local res
  
  for k, v in ipairs(t) do
    res[#res+1] = v
  end
  
  return res
end

return _A
