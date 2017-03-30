-- The next line shows how to supply your own usage via comment directive.
-- Usage: specify a command or function and receive help. Supply your own help using the -- Usage: directive, or check the Help global variable, see {{etc.cmdchar}}{{etc.cmdchar}}help for more info.

Help = {} -- This variable will be set, you can check for it to respond to help.
-- You can set Help.handled = true to fully control the help output.
-- Note: do not use the Usage comment directive if you intend to run code.

local LOG = plugin.log(_funcname);

if not arg[1] then
  local s = etc.helpmore(5)
  return "What do you want help with? I have so many commands, here's a few: " .. etc.cmdprefix .. "help " .. etc.cmdprefix .. "find" .. s
elseif arg[1] == "find" or arg[1] == "'find" or arg[1] == etc.cmdprefix .. "find" then
  return "Use the find command to find commands by name! " .. etc.cmdprefix .. "find cat - Use wildcards like * and ?, or enclose in quotes to be more specific."
else
  local x = arg[1]
  if arg[2] == '-tryagain' then
    x = x:match("[^%." .. etc.cmdchar .. "']+$") or x
    local nbwithin = #x * 1.5 + 2
    local nbest = nbwithin
    local best = nil
    local bestmod = 'etc'
    for imod, mod in ipairs{'etc', 'plugin', 'tests'} do
      local trying = _G[mod].find(x, true)
      for i = 1, #trying do
        local xd = math.abs(#x - #trying[i])
        -- Penalty if not starting/ending with same char.
        if x:sub(1, 1):lower() ~= trying[i]:sub(1, 1):lower()
            and x:sub(-1, -1):lower() ~= trying[i]:sub(-1, -1):lower() then
          xd = xd + 2
        end
        xd = xd + imod - 1 -- More unlikely each module.
        if xd < nbwithin then
          LOG.trace("Could possibly be", mod, trying[i])
        end
        if xd < nbest then
          nbest = xd
          best = trying[i]
          bestmod = mod
          LOG.debug("Getting closer with", bestmod, best, "@", nbest)
        end
      end
    end
    if best then
      local what
      if bestmod == 'etc' then
        what = etc.cmdprefix .. best
      else
        what = bestmod .. "." .. best
      end
      return 'Looking up ' .. what .. ' instead', "-", etc.help(what)
    end
  end
  local tx = type(x)
  local func
  if tonumber(x) then
    return etc.numberToWords(tonumber(x)) .. "..."
  elseif tx == "nil" then
    return "nil is very special..."
  elseif tx == "boolean" then
    return tostring(x) .. "!"
  elseif tx == "function" then
    func = x
    x = tostring(x)
  elseif tx ~= "string" then
    return tx .. "? those are cool"
  end
  if not func then
    local gh = _getHelp(x)
    if gh then
      return x .. " help:", gh
    else
      if etc.islua(x) == 1 then
        local a, b = pcall(etc.luaref, x)
        return x .. " is part of the Lua API:", (b or ""), "http://www.lua.org/manual/5.1/manual.html#pdf-" .. x
      else
        local gt = _G[x]
        if gt ~= nil then
          return x .. " is a", type(gt), "that's all I know"
        end
      end
    end
  end
  if not func then
    local pfx, a, b = x:match("^([" .. etc.cmdchar .. "']?)([^%.]*)%.?(.*)$")
    if a and b and #a > 0 then
      if #b > 0 then
        if type(_G[a]) == "table" then
          func = _G[a][b]
          x = a .. '.' .. b
        end
      end
      if not func and (pfx == etc.cmdprefix or pfx == "'") then
        func = etc[a]
        x = a
      end
    end
    if func and (pfx == etc.cmdprefix or pfx == "'") then
      -- x = "etc." .. x
      x = etc.cmdprefix .. x
    end
  end
  atTimeout("Sorry, I couldn't get any information about " .. tostring(x))
  src = getCode(func)
  if not src then
    if x:find("^[^%a]") then
      return x .. " to you too..."
    -- elseif x:find("%.") then
    --   return nil, "Sorry, can't help with " .. x .. " yet"
    else
      if etc[x] then
        -- return nil, "Sorry, I don't know about " .. x .. ", did you mean '" .. x
        return "Looking up " .. etc.cmdprefix .. x .. " instead", "-", etc.getReturn(etc.help(etc.cmdprefix .. x))
      else
        if tx == "string" and arg[2] ~= '-tryagain' then
          return etc.help(x, '-tryagain')
        end
        return nil, "Sorry, I don't know about " .. x
      end
    end
  end
  local usage = src:match("%-%-%[?=*%[? *[Uu]sage: *([^\r\n]+)")
  if usage then
    if usage:find("{{", 1, true) then
      usage = usage:gsub("({{( *.- *)}})", function(wholex, x)
        if x == "etc.cmdchar" then
          return etc.cmdchar
        elseif x == "etc.cmdprefix" then
          return etc.cmdchar
        elseif x == "" then
          return "" -- Can use {{}} if you just want to stop the auto cmd prefix fixer.
        else -- TODO: support more stuff.
          return wholex
        end
      end)
    else -- No {{ found, so we'll just try to fix broken uses of cmd prefix.
      local name = arg[1]:match("[a-zA-Z_][^ ]*")
      if name then
        --[[
        -- I could make sure the pattern ends with %f[%w]
        -- so 'foo doesn't also change 'foobar, but if it has the same prefix, maybe it's good fixed.
        usage = usage:gsub("'" .. name, etc.cmdprefix .. name)
        -- Do it for / prefix too, so the reverse happens when needed...
        usage = usage:gsub("/" .. name, etc.cmdprefix .. name)
        --]]
        -- Let's just do it for everything with any cmd prefix that's a valid etc func...
        usage = usage:gsub("(['/]([%w%.]+))", function(wholex, x)
          if etc[x] then
            return etc.cmdprefix .. x
          else
            return wholex
          end
        end)
      end
    end
    return x .. " usage:", usage
  end
  
  if etc.isalias(func) then
    local aa = etc.isalias(func)
    return "Alias for " .. aa, "-", etc.getReturn(etc.help(aa))
  end
  
  -- Let's disable functions that use coroutines, since pcall will flip out.
  httpGet = function(url) return "Data from " .. (url or "some url"), "text/plain" end
  sleep = function() end
  setTimeout = function() end
  io = io or {}
  local realopen = io.open
  io.open = function(fp, mode)
    if mode == 'r' or mode == 'rb' then
      return realopen(fp, mode)
    end
    return nil, "Permission denied (help)"
  end
  etc.set = function() return nil, "Permission denied (help)" end
  os = os or {}
  os.remove = function() return nil, "Permission denied (help)" end
  os.rename = function() return nil, "Permission denied (help)" end
  
  -- local a, b = pcall(etc.getOutput, func)
  local a, b = pcall(etc.getOutput, function(x) return guestloadstring("select(1, ...)()")(x) end, func)
  local handled = Help and Help.handled
  Help = nil -- Clear it so I can call things normally, like etc.on_src.
  if not a or (type(b) == "string" and b:find("^Error: ")) then
    local xtrafail = ""
    local fowner = owner(func)
    if fowner then
      xtrafail = " (" .. nick .. " * please let " .. (getname(fowner) or fowner) .. " know this happened)"
    end
    return nil, "I tried to call " .. x .. " but it failed with: " .. b .. xtrafail
  end
  local xs
  if b then
    if handled then
      return b
    end
    -- If it says Usage near the beginning then I'm happy...
    if type(b) == "string" and b:find("^.?.?.?.?.?.?.?.?.?.?.?.?[Uu]sage") then
      return b
    end
    if type(b) == "table" or (type(b) == "string" and b:find("^table: 0x")) then
      xs = "gave me a table, check it out: " .. (etc.on_src(x or "") or ("use " .. etc.cmdchar .. etc.cmdchar))
    else
      xs = "gave me: " .. tostring(b):match("^[^\r\n]*")
    end
  else
    xs = "didn't return anything; check it out: " .. (etc.on_src(x or "") or ("use " .. etc.cmdchar .. etc.cmdchar))
  end
  return "I don't know much about " .. x .. " but when I called it, it", xs
end
