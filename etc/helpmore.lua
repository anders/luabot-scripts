API "1.1"

-- This is called by 'help to show some commands you might want to call.

local WANT = tonumber(arg[0]) or 15
local t = etc.find("*", true)
local nfound = 0
local maxtries = 50
for i = 1, maxtries do
  if nfound < WANT then
    local r = math.random(#t)
    local isbad = t[r]:find("^on_") or t[r]:find("^cron_") or t[r]:find("^_")
    local code = getCode('etc', t[r])
    local hasusage = code:find("Usage", 1, true)
    local foolish = code:find("[Dd]eprecated") or code:find("[Ee]xperiment")
    local desperate = i >= ((maxtries - 7) - nfound)
    local lonely = i >= (maxtries - nfound)
    if lonely or (not isbad and hasusage and (not foolish or desperate)) then
      nfound = nfound + 1
      t[nfound], t[r] = t[r], t[nfound]
    end
  end
end
local s = ""
for i = 1, WANT do
  s = s .. " " .. etc.cmdprefix .. t[i]
end
return s
