local t = arg[1]
local tt = type(t)
if tt == "string" then
  local a, b = godloadstring("return " .. t)
  if a then
    t = a()
    tt = type(t)
  end
end
assert(tt == "table", "Need a table!")
local short = arg[2] or arg[2] == nil -- This is correct.

local s = ""
for k, v in pairs(t) do
  if s:len() > 0 then
    s = s .. ", "
  end
  k = tostring(k)
  if not short and type(v) == "table" then
    v = "{" .. etc.t(v, short) .. "}"
  else
    v = tostring(v)
    if short then
      if k:len() > 50 then
        k = k:sub(1, 50 - 3) .. "..."
      end
      k = k:gsub('[\r\n\t%z ]+', ' ')
      if v:len() > 100 then
        v = v:sub(1, 100 - 3) .. "..."
      end
      v = v:gsub('[\r\n\t%z ]+', ' ')
    end
  end
  s = s .. k .. '=' .. v
end

return s
