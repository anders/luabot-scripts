-- Usage: writes a message to a debug log. Prefer to use plugin.log

if Editor then return end

local websubdir = "debuglog"
local logdir = "/pub/web/" .. websubdir

if not arg[1] then
  return etc.dir("/user/$guest" .. logdir)
end

local msg = etc.stringprint(...)
local entry = etc.logformat(msg, "[%d] %m%n")
return etc.debuglograw(entry)
