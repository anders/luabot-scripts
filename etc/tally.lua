local t = {}
local function f(ft)
  for i, name in ipairs(ft.find('*', true)) do
    local o = getname(owner(ft[name])) or 'n/a'
    t[o] = (t[o] or 0) + 1
  end
end
for _, m in ipairs{etc, plugin} do f(m) end
print(etc.t(t))
