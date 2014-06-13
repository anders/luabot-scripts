API "1.1"

if #arg == 1 then
  if type(arg[1]) == "string" then
    local s = arg[1] or ''
    local t = {}
    for ch in etc.codepoints(s) do
      t[#t + 1] = ch
    end
    return t
  elseif type(arg[1]) == "table" then
    return arg[1]
  end
end
return { ... }
