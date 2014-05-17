local function getCached()
  for i=1, 10 do
    local k = 'hn'..i
    local v = Cache[k]
    if v then
      Cache[k] = nil
      return v
    end
  end
end

local title = getCached()
if not title then
  local data = httpGet('http://grantslatton.com/hngen/')
  local i = 1
  for t in data:gmatch('<li>([^<]+)</li>') do
    Cache['hn'..i] = html2text(t)
    i = i + 1
  end
  
  return getCached()
end

return title



