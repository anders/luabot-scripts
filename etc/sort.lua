function ord(cp)
  v = 0
  for i = 1, #cp do
    v = bit.lshift(v, 8)
    v = string.byte(cp, i)
  end
  return v
end

t = {}
for cp in etc.codepoints(arg[1]) do
    table.insert(t, cp)
end

table.sort(t, function (a, b)
  return ord(b) > ord(a)
end)
return table.concat(t, "")
