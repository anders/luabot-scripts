-- Usage: etc.debuglograw(arg1) - arg1 as a string will be written as-is; arg1 as a callback function gets a file object.

if Editor then return end

local websubdir = "debuglog"
local logdir = "/pub/web/" .. websubdir

local fs = assert(assert(guestloadstring("return io.fs"))(), "Need guest fs")
fs.mkdir(logdir)

LocalCache.lastdebuglogid = _threadid
local logname = _threadid .. ".log"
local f = assert(fs.open(logdir .. "/" .. logname, "a+"))
if type(arg[1]) == "function" then
  callback(f)
else
  f:write(arg[1])
end
f:close()

if not Private.debuglog_once then
  Private.debuglog_once = true
  
  -- remove old debug logs after expiretime...
  local expiretime = 60 * 5
  local now = os.time()
  local n = 0
  for k, v in ipairs(fs.list(logdir, 'f')) do
    local attr = fs.attributes(v)
    if now >= attr.modification + expiretime then
      n = n + 1
      fs.remove(v)
    end
  end
  
  -- etc.u isn't trusted!
  -- Private.debuglog_ret = etc.u("$guest " .. websubdir .. "/" .. logname)
  Private.debuglog_ret = boturl .. "u/" .. urlEncode("$guest") .. "/" .. websubdir .. "/" .. logname
  
end

return Private.debuglog_ret
