API "1.1"

local t = {}

local olderthan = tonumber(arg[1]) or (60 * 60 * 24 * 1)
local wantscores = arg[2] == '-wantscores'

for i, pkgname in ipairs{"etc"} do
  for ii, fname in ipairs(_G[pkgname].find("*", true)) do
    t[#t + 1] = { pkgname .. "." .. fname, _getCallInfo(pkgname, fname) }
  end
end

local now = os.time()

local function getscore(x)
  local ncalls = x[2]
  local lctime = x[3]
  local tdiff = now - lctime
  if tdiff < olderthan then
    return -ncalls
  else
    return ncalls + (tdiff / (60 * 60))
  end
end

table.sort(t, function(a, b)
  return getscore(b) < getscore(a)
end)

for i = 1, math.min(100, #t) do
  local x = t[i]
  if wantscores then
    print(x[1], math.floor(getscore(x)))
  else
    print(x[1])
  end
end
