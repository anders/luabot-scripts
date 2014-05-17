assert(Web and Web.GET and Web.GET.plugin)
print = function(line)
  Web.write(line .. '\n')
end
etc.munin_graph(etc["_graph_" .. Web.GET.plugin]())
