local LOG = plugin.log(_funcname);

LOG.trace("wrapping input")

if not arg[1] then
  LOG.debug("input is nil")
  return ''
end

local flags, str
if arg[2] then
  str = arg[1]
  if type(arg[2]) == "table" then
    flags = arg[2]
  else
    flags = {}
  end
else
  local pipepos = Input.piped or #arg[1]
  
  local haystack = arg[1]:sub(1, pipepos)
  local argstr = arg[1]:sub(pipepos + 1)
  local needle
  flags, needle = etc.getArgs(etc.splitArgs(argstr))
  
  str = haystack
  if needle and #needle > 0 then
    str = haystack .. ' ' .. needle
  end
end

-- local notutf8 = flags.p or flags["not-utf8"]
local maxlines = tonumber(flags.maxLines) or tonumber(flags["max-lines"]) or Output.maxLines or 4
local linelength = tonumber(flags.linelength) or tonumber(flags["line-length"]) or tonumber(flags.linelen) or 400
local merge = flags.m or flags.merge or flags["merge-if-wrap"]
local mergelinesep = flags["merge-line-separator"] or flags.mergelineseparator or flags.mergelinesep or '\t'
local basic = flags.basic or flags.b -- Basic wrap? otherwise break on words.
local cont = flags["continue"] or "..."
local longlastline = flags.longlastline -- Don't clip last line if exhausting maxlines.
local result = flags.result -- Want the result returned rather than printed.

assert(type(cont) == "string", "--continue=value must be a string")
assert(#cont < linelength, "--continue=\"" .. cont .. "\" is too long for --linelength=" .. linelength)

LOG.trace("maxlines:", maxlines)

if maxlines < 1 then
  local LOG = plugin.log(_funcname);
  LOG.debug("max lines set to", maxlines)
  return ''
end

-- TODO: don't break in middle of utf-8 sequence unless notutf8.

if merge then
  -- str = str:gsub("[\r\n]+", mergelinesep) -- Naive and ugly.
  local lines = {}
  for line in str:gmatch("[^\r\n]+") do
    lines[#lines + 1] = line
  end
  while #lines > maxlines do
    local shortline = 0
    local mergewith = 0
    local shortlen = math.huge
    for i = 1, #lines do
      if #lines[i] < shortlen then
        local prevlen = math.huge
        local nextlen = math.huge
        if lines[i - 1] then
          prevlen = #lines[i - 1]
        end
        if lines[i + 1] then
          nextlen = #lines[i + 1]
        end
        if prevlen <= nextlen then
          mergewith = i - 1
        elseif prevlen > nextlen then
          mergewith = i + 1
        end
        shortlen = #lines[i]
        shortline = i
      end
    end
    if shortline == 0 or not lines[mergewith] then
      LOG.debug("Naive and ugly.")
      str = str:gsub("[\r\n]+", mergelinesep)
      break
    end
    assert(shortline ~= mergewith)
    assert(shortline == mergewith - 1 or shortline == mergewith + 1)
    LOG.trace("Merging line " .. shortline .. " with " .. mergewith)
    if mergewith < shortline then
      lines[mergewith] = lines[mergewith] .. mergelinesep .. lines[shortline]
    else --if mergewith > shortline then
      lines[mergewith] = lines[shortline] .. mergelinesep .. lines[mergewith]
    end
    for i = shortline, #lines do
      lines[i] = lines[i + 1]
    end
  end
  str = table.concat(lines, mergelinesep)
end

local output = print
local toutput
if result then
  toutput = {}
  output = function(str)
    toutput[#toutput + 1] = str
  end
end

local istr = 1
while #str - istr - 1 > linelength do
  local inext = istr + linelength - #cont
  local skipspace = false
  if not basic then
    local maxseek = math.floor(linelength / 4)
    for ix = inext - 1, math.max(istr, inext - 1 - maxseek), -1 do
      local ch = str:sub(ix, ix)
      if ch == ' ' or ch == '\t' then
        if ix > istr then
          inext = ix
          skipspace = true
        end
        break
      end
    end
  end
  output(str:sub(istr, inext - 1) .. cont)
  istr = inext
  if skipspace then
    istr = istr + 1
  end
  maxlines = maxlines - 1
  if maxlines <= 1 then
    if longlastline then
      break
    end
    if maxlines == 0 then
      return
    end
  end
end
if #str >= istr then
  output(str:sub(istr))
end

if toutput then
  return table.concat(toutput, "\n")
end
