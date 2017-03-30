if type(arg[1]) == "function" then
  return arg[1], arg[2]
end
-- Uses ' hardcoded, otherwise / conflicts with the FS!
local pfx, a, b = (arg[1] or ''):match("^('?)([^'%.]*'?)%.?(.*)$")
-- print("Debug:", "pfx=", pfx, "a=",a,"b=",b)
if a and b then
  if pfx == "'" and b == '' then
    b = a
    a = "etc"
  end
  if _G[a] then
    if type(_G[a]) == "table" and _G[a][b] then
      return _G[a][b], a .. "." .. b
    elseif b == '' then
      return _G[a], a
    end
  end
end
return nil, "Function not found"
