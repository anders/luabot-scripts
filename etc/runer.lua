local fn, extra = arg[1]:match("'([^ ]+) (.+)")
if not fn then
  fn = arg[1]:match("'([^ ]+)")
  extra = nil
end

assert(fn,'pls fn')

for k, name in ipairs(etc.find('*', true)) do
  if etc.er(name) == fn then return etc.er(etc.getOutput(etc[name], extra)) end
end

print(etc.er('no match for '..fn))
