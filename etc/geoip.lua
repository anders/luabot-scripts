assert(type(arg[1]) == "string", "Need a string IP address")

local addr = arg[1]
local geoipfile = "geoip.txt"
local longip = etc.longip(addr)
if type(longip) ~= "number" then
  geoipfile = "geoipv6.txt"
  longip = etc.longipv6(addr)
  if not longip then
    return nil, "Expected an IP address"
  end
end

require "csv"

local match = etc.binarySearchFileLines("/shared/" .. geoipfile, function(line)
  line = line:gsub([[", "]], [[","]])
  local t = csv.parseLine(line)
  local longip_start = tonumber(t[3])
  local longip_end = tonumber(t[4])
  -- assert(longip_start, "longip_start="..tostring(longip_start).." in "..line)
  if longip >= longip_start then
    if longip <= longip_end then
      return 0
    else
      return 1
    end
  else
    return -1
  end
end)

if match then
  local line = match:gsub([[", "]], [[","]])
  local t = csv.parseLine(line)
  return t[5], t[6]
end
return nil, "IP address not found"
