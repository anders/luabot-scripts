API "1.1"
-- Usage: etc.historyfileopen(fmt) - fmt is optional, defaults to "%t <%n> %m"; returns a file object to read from the history.

local f, err = etc.listfile(function(i)
  local msg, nick, time = _getHistory(i)
  if not msg then
    return nil
  end
  local ex = ""
  if fmt == "*L" then
    ex = "\n"
  end
  return self._msgfmt:gsub("%%(.)", function(x)
    if x == "t" then
      return etc.duration(os.time() - time, 1) .. " ago"
    elseif x == "n" then
      return nick
    elseif x == "m" then
      return msg
    -- elseif x == "%" then
    --   return "%"
    else
      return "%" .. x
    end
  end) .. ex
end)

if not f then
  return f, err
end

f._msgfmt = arg[1] or "%t <%n> %m"

return f
