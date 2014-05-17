local s = assert(arg[1], "Input expected")
assert(type(s) == "string", "String expected")
local minlen = arg[2] or 4

local onechar = "[\032-\126]"
local pat = ""
for i = 1, minlen do
  pat = pat .. onechar
end
pat = pat .. "+"

local n = 0
for x in s:gmatch(pat) do
  if n >= Output.maxLines then
    break
  end
  print(x)
  n = n + 1
end

-- return n
