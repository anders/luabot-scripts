local p = (arg[1] or "")

if p:sub(1, 1) ~= '/' then
  p = "/user/" .. nick .. "/home/" .. p
end

return boturl .. "u/" ..
  urlEncode(getname(owner())) ..
  "/dir.lua?p=" ..
  urlEncode(p):gsub("%%2F", "/")
