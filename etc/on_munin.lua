-- assert(allCodeTrusted() and Event and Munin)
Cache.munin_last = Munin.line
if Event.name == "munin-connect" then
  Munin.write("# munin node at ludebot\n")
  return
end
local cmd, param = Munin.line:match("^([^ ]+) ?(.*)")
if cmd then
  local plugins = {
    "cbcworth",
    "botstocks",
  }
  local function getplugin(name)
    for i = 1, #plugins do
      if plugins[i] == name then
        return etc["_graph_" .. name]
      end
    end
  end
  if cmd == "list" then
    Munin.write(table.concat(plugins, " ") .. "\n")
  elseif cmd == "nodes" then
    Munin.write("ludebot\n")
    Munin.write(".\n")
  elseif cmd == "config" or cmd == "fetch" then
    local pf = getplugin(param)
    if not pf then
      Munin.write("# Unknown service\n")
    else
      local a, t, c = pcall(pf)
      assert(a, t)
      assert(t, c)
      local result, e = etc.getOutput(etc.munin_graph, t, cmd)
      assert(result, e)
      result = result:gsub("[\r\n]+$", "") .. "\n"
      Munin.write(result)
    end
    Munin.write(".\n")
  elseif cmd == "version" then
    Munin.write("lmnode on ludebot version: 1.0\n")
  elseif cmd == "cap" then
    Munin.write("cap\n")
  elseif cmd == "quit" then
    Munin.disconnect()
  else
    Munin.write("# Unknown command.\n")
  end
end
