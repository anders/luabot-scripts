-- Usage: etc.translateWords(s ,callback) the callback can return new word, false to skip, or nil to keep the same word.
local str = assert(arg[1])
local callback = assert(arg[2], "Callback expected")
local fixCase = arg[3] == nil or arg[3] == true
local nickpat = arg[4]

local prev = 1
local result = ""
local pat = "()([%w'%-\194-\244\128-\191]+)()"
if nickpat then
  pat = "()([%w'%-\194-\244\128-\191_%{%}%[%]`%^]+)()"
end
for wpos, w, wposEnd in str:gmatch(pat) do
  local wnew = callback(w)
  if wnew ~= false then
    result = result .. str:sub(prev, wpos - 1)
    if wnew then
      if fixCase then
        if w == w:lower() then
        elseif w == w:upper() then
          wnew = wnew:upper()
        elseif w:sub(1, 1) == w:sub(1, 1):upper() then
          wnew = wnew:sub(1, 1):upper() .. wnew:sub(2)
        end
      end
      result = result .. wnew
    else
      result = result .. w
    end
    if not wnew then
      wnew = w
    end
  end
  prev = wposEnd
end
result = result .. str:sub(prev)
return result
