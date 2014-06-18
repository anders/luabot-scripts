-- Locates IP/User
--
-- Arguments: <username/ip>

local json = plugin.json() 

--
-- Prints help
--
local function printUsage()
  print "Usage: 'locate <username/ip>"
end


--
-- Reads specified parameter.
-- If it contains dot (irc nicks cannot) it is taken as IP.
-- If not, it get's specified username IP. [TODO]
--
local function readParam(param)
  if param:find(".") then
    return param
  else
    return getHostNameOf(param)
  end
end


--
-- Gets users IP
--
local function getHostNameOf(s)
  -- TODO: Fix this
  return etc.get('host', s)
end


--
-- Main
--
local function locate(s)
  local ip = readParam(s)
  local geodata
  local jsonData
  local result
  
  if ip == "127.0.0.1" or ip == "localhost" then
    print "Nice try sucker"
    return
  end
  
  geodata = httpGet("http://freegeoip.net/json/"..ip)
  
  if (geodata == nil) or (geodata:sub(0,6) == "<html>") then
    print "Error: Cannot read geoip data"
    return
  end
  
  jsonData = json.decode(geodata)
  
  if jsonData.country_name == "Reserved" then
    result = string.format("%s is reserved", ip)
  else
    result = string.format("%s is from %s", ip, jsonData.country_name)
  end
  
  print (result)
end




if #arg > 0 then
  locate(arg[1])
else
  printUsage()
end
