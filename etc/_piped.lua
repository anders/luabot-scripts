--[[
Cache._p = (Cache._p or 0) + 1
return "(" .. tostring(Cache._p) .. "):"
  .. tostring(Input.piped or "no")
  .. " arg[1]=" .. tostring(arg[1])
--]]


-- 'echo goat | '_piped face
-- '_piped hello | '_piped world

-- Can use etc.getInputArgs to split args from stdin.


Cache._p = (Cache._p or 0) + 1
return "{ (call#" .. tostring(Cache._p) .. "):"
  .. tostring(Input.piped or "<not_piped>")
  .. " arg[1]=" .. tostring(arg[1]) .. " }"
