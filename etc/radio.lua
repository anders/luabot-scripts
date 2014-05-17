-- Usage: lists radio mountpoints @ anders radio server

local csv = require 'csv'

local data = httpGet('http://radio.fgsfd.se/status2.xsl')
if not data then return end

local p = csv.parse((data:match('<pre>(.+)</pre>')))

local sources = {}

-- mountpoint, connections, stream name, current listeners, description, currently playing, Earl
-- 1           2            3            4                  5            6                  7

local function f(s, def)
  if s == '' then return def end
  return s
end

if #p < 3 then
  print('no active streams')
  return
end

for i=3, #p do
  local MountPoint = p[i][1]
  local Name = f(p[i][3], 'untitled')
  local Listeners = p[i][4]
  local Description = f(p[i][5], 'no desc')
  local Current = f((p[i][6] or ''):sub(4), 'no track')
  
  local URL = 'http://radio.fgsfd.se:8000' .. MountPoint .. '.m3u'
  
  print('tune in: '..URL..' ('..Listeners..' listener(s), currently playing: '..Current..')')
end