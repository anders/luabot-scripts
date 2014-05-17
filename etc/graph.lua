-- Usage: 'graph <which> - specify which graph you want to see. Create a _graph_* function and send a request to add graphs.
if type(arg[1]) ~= "string" then
  local graphs = ""
  for i, v in ipairs(etc.findFunc('^_graph_')) do
    graphs = graphs .. " " .. v:sub(8)
  end
  return nil, "Which graph?" .. graphs
end
return boturl .. "u/" .. urlEncode(getname(owner())) .. "/graph.lua?plugin=" .. urlEncode(arg[1])
