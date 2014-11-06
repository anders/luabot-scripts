API "1.1"

local t = {}

local olderthan = tonumber(arg[1]) or (60 * 60 * 24 * 2)

for i, pkgname in ipairs{"etc", "plugin"} do
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
    return ncalls
  end
end

table.sort(t, function(a, b)
  return getscore(b) < getscore(a)
end)

for i = 1, math.min(100, #t) do
  local x = t[i]
  print(x[1], getscore(x))
end
