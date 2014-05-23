local what, edit = ...

local this = edit and 'edit' or 'view'

if Help or not what then
  return "Usage: '"..this.." [module.]func"
end

local today = os.date("!*t")
if today.month == 4 and today.day == 1 then
  return "Sorry, luabot is now closed source. No open source hippies here bls."
end

if not what:find("%.") then
  what = "etc."..what
end

local mod, func = what:match("([a-z]+)%.([A-Za-z0-9_]+)")
if not mod or not func then
  return false, "See 'help '"..this.."."
end

local script_path = "/pub/scripts/"..mod.."/"..func..".lua"
--[[ Bug: #242
if not io.fs.exists(script_path) then
  return false, "FileNotFound: "..script_path
end
]]

local f = assert(io.open(script_path, "r"), "No such script.")
local script = assert(f:read("*a"))
f:close()

local line_count = #script:gsub("[^\n]", "")
if script:sub(-1, -1) ~= "\n" then
  -- Count last line as well.
  line_count = line_count + 1
end

local num_calls, last_call, mtime, owner_id = _getCallInfo(mod, func)
local script_url = ("%st/%s?module=%s&name=%s"):format(boturl, this, urlEncode(mod), urlEncode(func))
--local mtime_date = os.date("!%Y-%m-%d", mtime)
local dur = etc.duration(os.time() - mtime)
local script_info = ("(owned by %s, %d line%s, edited %s ago)"):format(getname(owner_id), line_count, line_count > 1 and 's' or '', dur)
if edit then
  local read_only = account ~= owner_id and "[read only] " or ""
  sendNotice(nick, read_only..script_url.." "..script_info)
else
  return nick.." * "..script_url.." "..script_info
end
