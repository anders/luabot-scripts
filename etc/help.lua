-- The next line shows how to supply your own usage via comment directive.
-- Usage: specify a command or function and receive help. Supply your own help using the -- Usage: directive, or check the Help global variable, see ''help for more info.

Help = {} -- This variable will be set, you can check for it to respond to help.
-- You can set Help.handled = true to fully control the help output.
-- Note: do not use the Usage comment directive if you intend to run code.


if not arg[1] then
  local t = etc.find("*", true)
  for i = 1, 5 do
    local r = math.random(#t)
    t[i], t[r] = t[r], t[i]
  end
  local s = ""
  for i = 1, 5 do
    s = s .. " 'help \2" .. t[i] .. "\2"
  end
  return "What do you want help with? I have so many commands, here's a few: 'help \2help\2 'help \2find\2" .. s
elseif arg[1] == "find" or arg[1] == "'find" then
  return "Use the find command to find commands by name! 'find cat - Use wildcards like * and ?, or enclose in quotes to be more specific."
else
  local x = arg[1]
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
        return x .. " is part of the Lua API:", "http://www.lua.org/manual/5.1/manual.html#pdf-" .. x
      else
        local gt = _G[x]
        if gt ~= nil then
          return x .. " is a", type(gt), "that's all I know"
        end
      end
    end
  end
  if not func then
    -- x = x:match("^'?(.*)$")
    -- func = etc[x]
    local pfx, a, b = x:match("^('?)([^%.]*)%.?(.*)$")
    if a and b and #a > 0 then
      if #b > 0 then
        if type(_G[a]) == "table" then
          func = _G[a][b]
          x = a .. '.' .. b
        end
      end
      if not func and pfx == "'" then
        func = etc[a]
        x = a
      end
    end
    if func and pfx == "'" then
      -- x = "etc." .. x
      x = "'" .. x
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
        return "Looking up '" .. x .. " instead", "-", etc.getReturn(etc.help("'" .. x))
      else
        return nil, "Sorry, I don't know about " .. x
      end
    end
  end
  local usage = src:match("%-%-%[?=*%[? *[Uu]sage: *([^\r\n]+)")
  if usage then
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
  
  local a, b = pcall(etc.getOutput, func)
  if not a then
    return nil, "I tried to call " .. x .. " but it failed with: " .. b
  end
  local xs
  if b then
    if Help and Help.handled then
      return b
    end
    -- If it says Usage near the beginning then I'm happy...
    if type(b) == "string" and b:find("^.?.?.?.?.?.?.?.?.?.?.?.?[Uu]sage") then
      return b
    end
    xs = "gave me: " .. tostring(b):match("^[^\r\n]*")
  else
    xs = "didn't return anything"
  end
  return "I don't know much about " .. x .. " but when I called it, it", xs
end
