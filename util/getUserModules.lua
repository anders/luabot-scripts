API "1.2"

local t = {}

for k, v in pairs(arg[1] or _G) do
  if type(v) == "table" and type(k) == "string" then
    if v.cmdprefix and v.findFunc then
      t[#t + 1] = k
    end
  end
end

local priority = {
  etc = 10,
  util = 9,
  plugin = 8,
}

table.sort(t, function(a, b)
  local ap = priority[a] or 1
  local bp = priority[b] or 1
  if ap ~= bp then
    return bp < ap
  end
  return (b or "") < (a or "")
end)

return t
