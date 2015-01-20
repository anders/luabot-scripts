API "1.1"

local s = arg[1] or ''
while true do
  local foo, bar = s:match("(.*) ([^ ]+)[,%.!%?:;]*$");
  if not etc.isExtraWord(bar) then
    break
  end
  s = foo
end
return s
