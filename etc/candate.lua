local age = tonumber(arg[1]) or etc.getAge(...)
if not age then return nil, "Need to set age" end
return age/2+7
