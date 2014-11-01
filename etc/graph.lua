-- Usage: 'graph or 'graph <which> - view a graph. Create a _graph_* function and send a request to add graphs.

if type(arg[1]) ~= "string" then
  local graphs = ""
  --[[
  for i, v in ipairs(etc.findFunc('^_graph_')) do
    graphs = graphs .. " " .. v:sub(8)
  end
  --]]
  graphs = " " .. table.concat(etc.munin_conf().plugins, " ")
  return nil, "Which graph?" .. graphs
end

return etc.graphs(...)
