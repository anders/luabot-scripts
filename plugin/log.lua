-- Usage: local LOG = plugin.log(_funcname); - LOG.debug("foo"); LOG.info("bar"); LOG.warn("baz") LOG.error("oh no"); - Logging like log4j/log4net.

local M = {}

M.funcname = ...

local Level = {
  TRACE = 1,
  DEBUG = 2,
  INFO = 3,
  WARN = 4,
  ERROR = 5,
  FATAL = 6,
}

--[[
local levelbynum = {}
for k, v in pairs(Level) do
  levelbynum[v] = k
end
--]]

---
M.Level = etc.clone(Level)

local level
local printlevel

---
function M.setLevel(x)
  if type(x) == "number" then
    level = x
  elseif type(x) == "string" then
    level = assert(Level[x], "No such level " .. x)
  end
end

--- Automatically directly print this level. This is bounded by the normal level.
function M.setPrintLevel(x)
  if type(x) == "number" then
    printlevel = x
  elseif type(x) == "string" then
    printlevel = assert(Level[x], "No such level " .. x)
  end
end

M.setLevel(Output.logLevel or Level.DEBUG) -- Default.
M.setPrintLevel(Level.FATAL) -- Default.

--- boolean
function M.isTraceEnabled()
  return level <= Level.TRACE
end

local function dolog(levelnum, levelname, ...)
  if levelnum >= level then
    -- M.url = etc.debuglog(M.funcname or "-", levelname, ...)
    local msg = etc.stringprint(...)
    local entry = etc.logformat(msg, nil, M.funcname, levelname)
    if levelnum >= Level.ERROR and setLastError then
      setLastError(entry)
    end
    M.url = etc.debuglograw(entry)
    if levelnum >= printlevel then
      directprint(entry)
    end
  end
end

---
function M.trace(...)
  dolog(Level.TRACE, "TRACE", ...)
end

---
function M.debug(...)
  dolog(Level.DEBUG, "DEBUG", ...)
end

---
function M.info(...)
  dolog(Level.INFO, "INFO", ...)
end

---
function M.warn(...)
  dolog(Level.WARN, "WARN", ...)
end

---
function M.error(...)
  dolog(Level.ERROR, "ERROR", ...)
end

---
function M.fatal(...)
  dolog(Level.FATAL, "FATAL", ...)
end

return M
