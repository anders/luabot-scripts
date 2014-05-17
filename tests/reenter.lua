if arg[2] then
  print("from " .. (nick or '???') .. ":", ...)
  print("By design this will keep going until it times out (or we don't call reenter again)")
end
local words = { etc.funword(), etc.funword(), etc.badword() }
print(("Say %s, %s or %s (%d)"):format(words[1], words[2], words[3], os.time()));
assert(reenter(words))
