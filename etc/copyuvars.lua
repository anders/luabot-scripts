if Editor then return end

local user = (arg[1] or nick):match('[^/]+')

local fn = 'uvars/'..user:lower()..'.json'

local settings = plugin.settings(io)

local t, e = settings.load(fn)
if not t then
  return false, e
end

if plsdecode then
  return t
end

assert(account, 'need to be identified with NickServ!')
local storage = require 'storage'
local userdata = storage.load(io, 'userdata-'..account..'.dat')

for k, v in pairs(t) do
  userdata[k] = v
end

assert(storage.save(userdata))

print 'Copied old vars.'
