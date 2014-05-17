-- http://stackoverflow.com/questions/4259770/reading-a-binary-file-into-an-array/4260972#4260972
local b1, b2, b3, b4 = ...
if not b1 then error("need four bytes to convert to int",2) end
if not b2 then
  b1, b2, b3, b4 = arg[1]:byte(1, 4)
end
local n = b1 + b2*256 + b3*65536 + b4*16777216
n = (n > 2147483647) and (n - 4294967296) or n
return n
