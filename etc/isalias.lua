local c = etc.code(...)
if not c then
  return nil, "No such function"
end
local a = c:match("^%s*return%s+([^%.]*%.?[%a_]+)%s*%(%s*%.%.%.%s*%)%s*$")
if a then
  return a
end
return false
