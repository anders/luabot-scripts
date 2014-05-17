-- arg[1] = function, arg[2+] = arguments for function
-- Optional extra first arg of boolean, true indicates wanting standard error to be the 2nd return value.

if type(arg[1]) == "boolean" then
  return etc.getOutput2(...)
else
  return etc.getOutput2(false, ...)
end

