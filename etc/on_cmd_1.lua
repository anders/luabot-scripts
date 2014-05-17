-- Fake pcall until coco applied. It's applied.
-- pcall = function(f, ...) return true, f(...) end

--[[ -- Doesn't work..
if Input then
  Input._set_iscmd = _func()
end
--]]

if LocalCache and LocalCache.lastmsg and LocalCache.lastmsg:sub(1, 1) == etc.cmdchar then
  LocalCache.lastcmd = LocalCache.lastmsg
  LocalCache.lastcmdnick = LocalCache.lastmsgnick
end

if LocalCache then
  if LocalCache.threadid ~= _threadid then
    LocalCache.lastthreadid = LocalCache.threadid
  end
  LocalCache.threadid = _threadid
end

-- directprint("on_cmd", "arg1=",arg[1],"arg2=",arg[2]) ------

local function getfunc(name)
  local x, y = name:match("^([^%.]+)%.(.+)$")
  if x and y then
    if not _G[x] then
      return nil
    end
    return _G[x][y]
  else
    return etc[name]
  end
end


local params = arg[2]
if type(params) == "number" then
  params = tostring(params)
end
if type(params) == "string" then
  local x, op, y, z = params:match("^(.-) *([%|;]) *'([a-zA-Z_0-9]+) ?(.*)$")
  if y then
    -- directprint(x, y, z)
    -- assert(etc[y], "Function not found: etc." .. y)
    -- assert(getfunc(y), "Function not found: '" .. y)
    assert(getfunc(y), "Function not found: '" .. y .. " (as in '" .. y .. " " .. tostring(z) .. ")")
    -- directprint("~1 Getting output of '" .. tostring(arg[1]) .. "(" .. tostring(x) .. ")")
    local a
    if x ~= "" then
      a = etc.getReturn(etc.getOutput(true, getfunc(arg[1]), x))
    else
      a = etc.getReturn(etc.getOutput(true, getfunc(arg[1])))
    end
    if op == ';' then
      if a ~= nil then
        print(tostring(a))
      end
      -- return etc.on_cmd(y, z) -- Won't print the return if the first cmd printed.
      a = etc.getReturn(etc.getOutput(etc.on_cmd, y, z))
      if a ~= nil then
        print(tostring(a))
      end
      return
    else
      if a == nil then
        a = ""
      else
        a = tostring(a)
      end
      -- local ipipe = 1
      local ipipe = a:len() + 1
      if z:len() > 0 then
        -- ipipe = a:len() + 1
        a = a .. ' ' .. z
      end
      Input = Input or {}
      local _ipiped1 = Input.piped
      Input.piped = ipipe
      return (function(...)
        Input.piped = _ipiped1
        return ...
      end)(etc.on_cmd(y, a))
    end
  end
end


return etc.getReturn((function(fname, ...)
  -- directprint("~3 Calling '" .. fname .. "(" .. tostring(select(1, ...)) .. ")")
  local f = getfunc(fname)
  if f then
    return f(...)
  end
end)(...))

