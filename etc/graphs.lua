-- Usage: 'graphs - view all graphs
local which = arg[1] or "index"

-- return boturl .. "t/graphs/ludebot/" .. which .. ".html"

if which == "index" then
  return etc.viewpage("graphs.lua", getname(owner()))
else
  return etc.viewpage("graph.lua?graph=" .. which, getname(owner()))
end
