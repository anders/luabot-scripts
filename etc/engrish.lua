-- Usage: your wildest dreams.
Input.piped = nil
local foo = assert(arg[1], "arg!")
local through = arg[2] or 'ja'
local from = arg[3] or 'xx'
for i = 1, 2 do
  foo = etc.translate(from .. ' ' .. through .. ' ' .. foo)
  -- print("->", foo)
  foo = etc.translate(through .. ' en ' .. foo)
  from = 'en'
end
-- print(foo)
return foo
