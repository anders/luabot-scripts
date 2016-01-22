API "1.2"

local LOG = plugin.log(_funcname);

local function getUtc()
  LOG.trace("getUtc")
  return os.date("!%c %Z")
end

if arg[1] == "--utc" then
  LOG.trace("--utc")
  return getUtc()
else
  LOG.trace("attempting to get local time...")
  local tz = etc.tz()
  if not tz then
    LOG.trace("could not get local time")
    return getUtc()
  end
  LOG.trace("local time: " .. tz)
  local zone, date = tz:match("%(([^%)]+)%): (.*)")
  if not zone or not date then
    LOG.trace("could not parse local time")
    return getUtc()
  else
    LOG.trace("parsed local time")
    return date .. " " .. zone
  end
end
