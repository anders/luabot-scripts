-- Usage: nick/user. Please 'set last.fm <username>
plugin._april_fools()

local json = plugin.json()
local stringx = plugin.stringx()
local settings = plugin.settings(io)

local user = arg[1] ~= '' and arg[1]

local API_KEY = "142e172267537d16cc28336c89339871"
user = etc.get("last.fm", arg[1]) or user or etc.get("last.fm", nick) or nick

local url = "http://ws.audioscrobbler.com/2.0?limit=2&method=user.getrecenttracks&format=json&user="..user.."&api_key="..API_KEY
local data = httpGet(url)
local parsed = assert(json.load(data))

errorCodes = {
  [2] = "Invalid service - This service does not exist",
  [3] = "Invalid Method - No method with that name in this package",
  [4] = "Authentication Failed - You do not have permissions to access the service",
  [5] = "Invalid format - This service doesn't exist in that format",
  [6] = "Invalid parameters - Your request is missing a required parameter",
  [7] = "Invalid resource specified",
  [8] = "Operation failed - Something else went wrong",
  [9] = "Invalid session key - Please re-authenticate",
  [10] = "Invalid API key - You must be granted a valid key by last.fm",
  [11] = "Service Offline - This service is temporarily offline. Try again later.",
  [13] = "Invalid method signature supplied",
  [16] = "There was a temporary error processing your request. Please try again",
  [26] = "Suspended API key - Access for your account has been suspended, please contact Last.fm",
  [29] = "Rate limit exceeded - Your IP has made too many requests in a short period"
}
setmetatable(errorCodes, {__index = function(t, k) return 'Unknown error' end})

assert(errorCodes[2] == "Invalid service - This service does not exist")
assert(errorCodes[1337] == "Unknown error")

if parsed.error then
  print("\002Last.fm API error:\002 "..parsed.message.." (code: "..parsed.error..", "..errorCodes[tonumber(parsed.error)]..")")
  return
end

local track = parsed.recenttracks.track and parsed.recenttracks.track[1]
if not track then
  print("\002Error:\002 No recently played tracks!")
  return
end


local artist = track.artist["#text"] or "artist?"
local title = track.name or "title?"
local is_playing = track["@attr"] and track["@attr"].nowplaying
local user = parsed.recenttracks["@attr"].user or "user?"
local url = track.url or "url?"

local is_playing_str = is_playing and "is playing" or "last played"

if not (network == "Telegram" and chan == "#-1677851") then
  print(("♫♪ \2%s\2 %s \2%s\2 by \2%s\2%s ♪♫"):format(user, is_playing_str, title, artist, url))
else
  etc.printf("\1MD 🎧　[%s](%s) %s [%s](%s) by [%s](%s)", user, "http://last.fm/user/"..user, is_playing_str, title, url, artist, url)
end
