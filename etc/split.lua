API "1.1"

local arg, stdio = etc.stdio(arg)
arg = etc.splitArgs(arg[1])

local data = stdio:read("*a")

local strfind, strsub, tinsert = string.find, string.sub, table.insert
local function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

for i, line in ipairs(strsplit(arg[1], data)) do
  print(line)
end
