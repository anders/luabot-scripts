local serializer = require 'serializer'

local MAX = 50

local cacheFile = 'confession_data.lua'
local confessions

local attr = os.attributes(cacheFile)
if attr and attr.modification + 1800 >= os.time() then
  confessions = serializer.load(io, cacheFile)
  if #confessions == 0 then
    confessions = nil
  end
end

if not confessions then
  local data = assert(httpGet('http://www.codingconfessional.com'))

  confessions = {}

  for confession in data:gmatch('confession">%s+([^<]+)') do
    confessions[#confessions + 1] = html2text(confession)
    if #confessions >= MAX then
      break
    end
  end
  
  serializer.save(io, cacheFile, confessions)
end

print(confessions[math.random(1, #confessions)])
