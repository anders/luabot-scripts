API "1.1"
-- Usage: js/jx style awk.

local LOG = plugin.log(_funcname);

return etc.lawk(arg[1], function(code, chunkname)
  code = code:gsub("%$(%d+)", function(sn)
    if sn == "0" then
      -- Cheat with Lua unpack...
      return "etc.stringprint(unpack(arg))"
    else
      -- Comma operator to disallow assignment...
      -- return "(0,arg[" .. sn .. "-1])" -- Not supported yet...
      return "_arg(arg," .. sn .. "-1)"
    end
  end)
  code = "arg=arguments[0]; var _arg = function(a,b){return a[b]} \t " .. code
  LOG.trace("Compiling", chunkname or "code", code)
  return etc.jxcompile(code, chunkname)
end);
