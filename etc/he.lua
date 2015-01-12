API "1.1"

if arg[1] then
  local x = arg[1]
  if x:sub(#x) == "'" then
    x = x:sub(1, #x-1)
  end
  x = etc.wrap(x, { ["max-lines"]=1, linelength=25, result=true })
  x = x:gsub("[^a-zA-Z0-9 ]+", "")
  return etc.me(x)
end
