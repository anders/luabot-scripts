API "1.2"
-- Usage: similar to the unix wc command. 'command | 'wc -l
-- Bug: byte and character counts not correct if no trailing newline at EOF.

arg, io.stdin = etc.stdio(arg)
local flags, filepath, filepath2 = etc.getArgs(arg)

if filepath2 then
  return nil, "Multiple files not supported yet, please bug byte[] about it"
end

filepath = filepath or "-"
local file = io.stdin
if filepath ~= "-" then
  file = assert(etc.userfileopen(filepath))
end

local dobytecount = flags.c or flags["bytes"]
local docharcount = flags.m or flags["chars"]
local dolinecount = flags.l or flags.lines
local domaxlinelen = flags.L or flags["max-line-length"]
local dowordcount = flags.w or flags.words

-- Important to get this right, or output will be wrong:
local numflags =
    (dobytecount and 1 or 0)
  + (docharcount and 1 or 0)
  + (dolinecount and 1 or 0)
  + (domaxlinelen and 1 or 0)
  + (dowordcount and 1 or 0)

if flags.help or flags.version then
  return bot .. " wc 1.0"
end

local lc = 0
local bc = 0
local cc = 0
local maxlinefound = 0
local wc = 0

for line in file:lines() do
  lc = lc + 1
  bc = bc + #line + 1
  if docharcount then
    for ch in etc.codepoints(line) do
      cc = cc + 1
    end
    cc = cc + 1
  end
  -- wordcount needed for default output
  for w in line:gmatch("[^%s]+") do
    wc = wc + 1
  end
  if #line > maxlinefound then
    maxlinefound = #line
  end
end

if numflags == 0 then
  -- Print newline, word, and byte counts for each FILE.
  print(string.format("%d %d %d %s", lc, wc, bc, filepath))
  -- Todo: if > 1 file, do this one per line and then total.
elseif numflags == 1 then
  if dobytecount then
    return bc
  elseif docharcount then
    return cc
  elseif dolinecount then
    return lc
  elseif domaxlinelen then
    return maxlinefound
  elseif dowordcount then
    return wc
  else
    assert(false)
  end
else
  return nil, "Mixed flags not supported yet, please bug byte[] about it"
end
