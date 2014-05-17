local xml = plugin.xml()
local cache = plugin.cache(Cache)

local function asshurt(exp, e, ...)
  if not exp then
    etc.printf(e, ...)
    halt()
  end
  return exp
end

local feed = asshurt(arg[1], '$BUsage:$B \'rss feed')

cache.auto('rss'..feed, 5 * 10, function()
  local data, err = httpGet(feed)
  assert(data, err)
  
  local parsed = xml.parse(data)
  etc.print_table(parsed)
  
  -- todo: use etc.shortenurl()
  for i=1, 3 do
    local item = parsed.rss.channel.item[i]
    etc.printf('%s - %s', item.title['#text'], item.link['#text'])
  end
end)