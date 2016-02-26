local age = tonumber(arg[1]) or etc.getAge(...)
if not age then return nil, "Need to set age" end
local nope = (age-7)*2+1
return nope <= age+1 and age+1 or nope
