local stringx = plugin.stringx()
local s = arg[1]
if not s then
  return
end
table.remove(arg, 1)
print(stringx.fmtstr(s, unpack(arg)))
