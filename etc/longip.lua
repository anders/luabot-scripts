if type(arg[1]) == "string" then
  local o1, o2, o3, o4 = arg[1]:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$")
  if o4 then
    return 2^24*o1 + 2^16*o2 + 2^8*o3 + o4
  end
end
return arg[1]
