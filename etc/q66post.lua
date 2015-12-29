API "1.1"

local history = {}
for i=1, 25 do
  local line, who, ts = _getHistory(i)
  if not line then
    break
  end
  
  if who ~= "q66" then
    history[#history + 1] = "<"..who.."> "..line
  end
end

if #history == 0 then
  return
end

local disagree_with = pickone(history)

local shitpost_generators = {
  function()
    return ">"..os.date("%Y").."\n<q66> >not q66posting"
  end,
  function()
    return "nice andersing"
  end,
  function()
    return ":V :V :V"
  end,
}

local q66post = pickone(shitpost_generators)()

print("<q66> "..disagree_with)
print("<q66> "..q66post)
