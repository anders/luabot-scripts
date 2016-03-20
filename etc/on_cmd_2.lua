-- Fake pcall until coco applied. It's applied.
-- pcall = function(f, ...) return true, f(...) end

-- ./ludebot-sync etc.on_cmd_2 etc.on_cmd_2.lua

-- Note: don't leave the LOG stuff in here, it messes with the lastdebuglogid.
-- local LOG = plugin.log(_funcname);
-- LOG.debug(etc.t(arg))

local cmdprefix = etc.cmdprefix

if LocalCache and LocalCache.lastmsg and LocalCache.lastmsg:sub(1, #cmdprefix) == cmdprefix then
  LocalCache.lastcmd = LocalCache.lastmsg
  LocalCache.lastcmdnick = LocalCache.lastmsgnick
end

if LocalCache then
  if LocalCache.threadid ~= _threadid then
    LocalCache.lastthreadid = LocalCache.threadid
  end
  LocalCache.threadid = _threadid
end

local cmd = arg[1]
local params = arg[2]
if type(params) == "number" then
  params = tostring(params)
end

local function getfunc(name)
  local mod = etc
  local x, y = name:match("^([^%.]+)%.(.+)$")
  if x and y then
    if not _G[x] then
      return nil
    end
    mod = _G[x]
    name = y
  end
  local f = mod[name]
  if f then
    return f
  end
  if mod.findFunc then
    local lowername = name:lower()
    local all = mod.findFunc()
    for i = 1, #all do
      if lowername == all[i]:lower() then
        f = mod[all[i]]
        assert(f, "Found function but could not get it")
        return f
      end
    end
  end
  return nil
end

Input = Input or {}
Input.piped = nil

-- Parse through the pipes and multiple commands:
if type(params) == "string" then
  local results
  local istart = 1
  local curcmd = cmd
  local cursepch = ';'
  local onfirst = true
  while true do
    local iend, sepch, nextcmd, inext =
      params:match("() *([;%|]) *" .. cmdprefix .. " *([a-zA-Z_0-9%.]+) ?()", istart)
    local is_last_cmd = true
    if iend then
      iend = iend - 1
      is_last_cmd = false
    else
      iend = #params
    end
    local curparams = params:sub(istart, iend)
    if curparams == "" then
      curparams = nil
    end
    local func = getfunc(curcmd)
    -- LOG.debug("Processing cmd=" .. (curcmd or "<N/A>") .. "; params=" .. (curparams or "<N/A>"))
    -- LOG.debug("Function=" .. tostring(func))
    -- Handle the command.
    if onfirst and iend == #params then
      -- Very simple with args.
      -- assert(func, "Function not found: " .. curcmd)
      if not func then
        -- local w = etc.randomDefinition()
        -- etc.tz(w)
        -- etc.birthday(w)
        return
      end
      return etc.getReturn(func(curparams))
    else
      assert(func, "Function not found: " .. curcmd)
      -- Notice sepch is for the next command, and cursepch was the one before this command.
      if is_last_cmd or sepch ~= '|' then
        Output.maxLinesSet = Output.maxLines -- Make sure getOutput doesn't change the maxLines.
      end
      if cursepch == '|' then
        if not curparams then
          curparams = results
          Input.piped = #results
        elseif curparams and results then
          Input.piped = #results + 1
          curparams = results .. " " .. curparams
        end
        local newresults = etc.getReturn(etc.getOutput(true, func, curparams))
        results = newresults
      else
        local newresults = etc.getReturn(etc.getOutput(true, func, curparams))
        if results then
          results = results .. "\n" .. newresults
        else
          results = newresults
        end
      end
    end
    -- Prepare for next.
    Input.piped = nil
    if iend == #params then
      break
    end
    istart = inext
    curcmd = nextcmd
    cursepch = sepch
    onfirst = false
  end
  if results then
    return results
  end
  return
else
  -- Very simple with no args.
  local curcmd = cmd
  local curparams = nil
  local func = getfunc(curcmd)
  -- LOG.debug("Processing cmd=" .. (curcmd or "<N/A>") .. "; params=" .. (curparams or "<N/A>"))
  -- LOG.debug("Function=" .. tostring(func))
  -- assert(func, "Function not found: " .. curcmd)
  if not func then
    -- local w = etc.randomDefinition()
    -- etc.tz(w)
    -- etc.birthday(w)
    return
  end
  return etc.getReturn(func(curparams))
end
