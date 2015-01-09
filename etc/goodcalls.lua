-- Usage: 'goodcalls <days> - try to find functions worth calling which haven't been used in a few days.

local LOG = plugin.log(_funcname)

local t = {}

local wantscores = arg[2] == '-wantscores'

local ndays = tonumber(arg[1]) or 5
local maxdur = 86400 * ndays

local now = os.time()

for i, pkgname in ipairs{"etc"} do
  for ii, fname in ipairs(_G[pkgname].find("*", true)) do
    local ncalls, lctime, mtime, owner = _getCallInfo(pkgname, fname)
    if lctime and mtime then
      local lcdur = math.min(maxdur, now - lctime)
      local mdur = math.min(maxdur, now - mtime)
      local score = lcdur + mdur + ncalls
      if score < maxdur * 2 then
        t[#t + 1] = { name = pkgname .. "." .. fname, score = score }
      end
    else
      LOG.debug("Skip unknown time", mm, ff, ncalls, lctime, mtime, owner)
    end
  end
end

table.sort(t, function(a, b)
  return b.score < a.score
end)

do
  local nresults = math.min(#t, 10, Output.maxLines or 10)
  local i = 1
  while i <= nresults do
    local x = t[i]
    if not etc.isalias(x.name) then
      i = i + 1
      if wantscores then
        print(x.name, math.floor(x.score))
      else
        print(x.name)
      end
    end
  end
end
