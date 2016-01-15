API "1.1"

if nick:find("gmcabrita") then
  print("<gmcabrita> meme")
  return
end

local history = {}
local activenicks = {}
for i=1, 25 do
  local line, who, ts = _getHistory(i)
  if not line then
    break
  end
  
  if who ~= "q66" then
    activenicks[who] = who
    history[#history + 1] = "<"..who.."> "..line
  end
end

if #history == 0 then
  return
end

local a = {}
for k, v in pairs(activenicks) do a[#a+1] = v end

local disagree_with = pickone(history)

local shitpost_generators = {
  function()
    return ">"..os.date("%Y").."\n<q66> >not q66posting"
  end,
  function()
    return "nice anderspost"
  end,
  function()
    return ":V :V :V"
  end,
  function()
    return "please refrain from "..pickone(a).."ing"
  end,
}

local q66post = pickone(shitpost_generators)()

print("<q66> "..disagree_with)
print("<q66> "..q66post)
