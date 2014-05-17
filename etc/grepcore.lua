local input = arg[1] -- Open file object.
local needle = arg[2]
local flags = arg[3]

local LOG = plugin.log(_funcname);

LOG.trace("input:", tostring(input))
LOG.debug("needle:", needle)
LOG.debug("flags:", etc.t(flags))

local plain = false
if flags.F or flags['fixed-strings'] then
  plain = true
end

local ci = false
if flags.i or flags['ignore-case'] then
  ci = true
  needle = needle:lower()
end

-- TODO: fix -i with -o outputting all-lowercase.
local only = flags.o or flags['only-matching']

local invert = flags.v or flags['invert-match']

local withFilename = flags.H or flags['with-filename']
local noFilename = flags.h or flags['no-filename']

local fmtwithfile = flags['format-with-filename'] or "%f:%s"
local fmtnofile = flags['format-no-filename'] or "%s"

local doIncludeFilename = input.grepIsMultiFile
    and input:grepIsMultiFile()
    and input.grepGetFilePath
if withFilename then
  doIncludeFilename = true
end
if noFilename then
  doIncludeFilename = false
end

-- Can't read flags.m, it will just be boolean.
local maxoutput = tonumber(flags['max-count']) or Output.maxLines or math.huge

-- for line in haystack:gmatch("[^\r\n]+") do
for line in input:lines() do
  if maxoutput < 1 then
    LOG.trace("hit max output")
    break
  end
  local checkline = line
  if ci then
    checkline = checkline:lower()
  end
  local m = checkline:match(needle, 1, plain)
  local output
  if invert then
    if not m then
      output = line
    end
  else
    if m then
      if only then
        output = m
      else
        output = line
      end
    end
  end
  if output then
    local fmt
    local xs = output
    local xf = input:grepGetFilePath() or "?"
    if doIncludeFilename then
      fmt = fmtwithfile
    else
      fmt = fmtnofile
    end
    maxoutput = maxoutput - 1
    print(fmt:gsub("%%(.)", function(x)
      if x == '%' then
        return '%'
      elseif x == 's' then
        return xs
      elseif x == 'f' then
        return xf
      else
        return "(%" .. x .. "?)"
      end
    end) or '')
  end
end
