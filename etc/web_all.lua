if not Web then
  local data = etc.getOutput(etc.all, arg[1], nil, "\n", "%n\t%s", true)
  Output.maxLines = 1
  etc.less((arg[1] or '') .. "\n\n" .. data)
  -- print(boturl..'u/' .. urlEncode(getname(owner())) .. '/all.lua?id=')
  return
end
