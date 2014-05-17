-- Usage: etc.output(...) outputs everything supplied. For a command to evaulate the args, use 'out ...

local delim = out_delim or " "

local tresult = {}
for i = 1, select('#', ...) do
  local x = select(i, ...)
  local tx = type(x)
  if tx == "table" then
    x = etc.t(x)
  else
    x = tostring(x)
  end
  table.insert(tresult, x)
end

print(table.concat(tresult, delim))
