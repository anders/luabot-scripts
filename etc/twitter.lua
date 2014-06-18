local xml = plugin.xml()
local cache = plugin.cache(Cache)

local function asshurt(exp, e, ...)
  if not exp then
    etc.printf(e, ...)
    halt()
  end
  return exp
end

local RSS_FEED = 'http://api.twitter.com/1/statuses/user_timeline.rss?screen_name='
local user = asshurt(arg[1], '$BUsage:$B \'twitter nick')

cache.auto('twitter_'..user, 5 * 10, function()
  local data, err = httpGet(RSS_FEED..urlEncode(user))
  assert(data, err)
  
  local parsed = xml.parse(data)
  
  -- todo: use etc.shortenurl()
  for i=1, 3 do
    local item = parsed.rss.channel.item[i]
    etc.printf('%s - %s', html2text(item.title['#text']), item.link['#text'])
  end
end)
