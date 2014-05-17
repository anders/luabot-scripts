local t = etc.splitArgs(arg[1])
local n = assert(tonumber(t[1]), 'number of lines bls')
local _, prevnick = _getHistory(1) -- get previous line info
prevnick = t[2] or prevnick

local prevlines = {}

local i = 0
while true do
  i = i + 1
  local msg, user, ts = _getHistory(i)
  if not msg then break end
  
  if user == prevnick then
    prevlines[#prevlines + 1] = msg
    if #prevlines == n then break end
  end
end

local buf = {'<'..prevnick..'> '}
for i=#prevlines, 1, -1 do
  buf[#buf + 1] = prevlines[i]
end

return table.concat(buf, '')
