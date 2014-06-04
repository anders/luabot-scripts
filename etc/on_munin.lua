-- assert(allCodeTrusted() and Event and Munin)
Cache.munin_last = Munin.line
if Event.name == "munin-connect" then
  Munin.write("# munin node at ludebot\n")
  return
end
local errors = {}
local cmd, param = Munin.line:match("^([^ ]+) ?(.*)")
if cmd then
  local plugins = etc.munin_conf().plugins
  local function getplugin(name)
    --[[
    for i = 1, #plugins do
      if plugins[i] == name then
        return etc["_graph_" .. name]
      end
    end
    --]]
    -- Don't bother checking so we can run tests.
    -- If it's not in list then the real munin won't even request it.
    return etc["_graph_" .. name]
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
      local realprint = print
      local realMunin = Munin
      Munin = nil
      print = function() end
      local a, t, c = pcall(pf)
      print = realprint
      Munin = realMunin
      -- assert(a, t)
      -- assert(t, c)
      if not a or not t then
        errors[#errors + 1] = "plugin " .. tostring(param) .. ": " .. tostring(t or c)
      else
        local result, e = etc.getOutput(etc.munin_graph, t, cmd)
        -- assert(result, e)
        if not result then
          errors[#errors + 1] = "plugin " .. tostring(param) .. ": " .. tostring(e)
        else
          result = result:gsub("[\r\n]+$", "") .. "\n"
          Munin.write(result)
        end
      end
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
if #errors then
  _clown()
  for i = 1, #errors do
    print("on_munin error in", errors[i])
  end
end
