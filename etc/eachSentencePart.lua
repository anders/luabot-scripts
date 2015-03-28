local str = assert(arg[1])
local callback = assert(arg[2], "Callback expected")
local wordsOnly = arg[3]
local nickpat = arg[4]

local prev = 1
local pat = "()([%w'%-]+)()"
if nickpat then
  pat = "()([%w_'%-%{%}%[%]`%^]+)()"
end
for wpos, w, wposEnd in str:gmatch(pat) do
  local x = str:sub(prev, wpos - 1)
  if not wordsOnly and #x > 0 then
    callback(x, false)
  end
  callback(w, true)
  prev = wposEnd
end
if not wordsOnly and prev < #str then
  callback(str:sub(prev), false)
end
