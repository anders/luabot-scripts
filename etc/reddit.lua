--
-- Reddit script by Anders
--
-- Changelog:
--
-- 2012-02-08:
--   initial version
-- 2012-02-28:
--   check for error from httpGet
-- 2014-05-09:
--   (byte[]) use reddit URLs
--

if Editor then return end

local json = plugin.json()
local cache = plugin.cache(Cache)
local stringx = plugin.stringx()

--[[ Example link entry:
"data": {
  "domain": "pastebin.com",
  "media_embed": {},
  "subreddit": "programming",
  "selftext_html": null,
  "selftext": "",
  "likes": null,
  "saved": false,
  "id": "pf1fc",
  "clicked": false,
  "title": "Anonymous Releases the Symantec Source Code",
  "media": null,
  "score": 872,
  "over_18": false,
  "hidden": false,
  "thumbnail": "",
  "subreddit_id": "t5_2fwo",
  "author_flair_css_class": null,
  "downs": 452,
  "is_self": false,
  "permalink": "/r/programming/comments/pf1fc/anonymous_releases_the_symantec_source_code/",
  "name": "t3_pf1fc",
  "created": 1328667592.0,
  "url": "http://pastebin.com/UmJy7Bb1",
  "author_flair_text": null,
  "author": "sidcool1234",
  "created_utc": 1328642392.0,
  "num_comments": 333,
  "ups": 1324
}
]]

local reddit = arg[1] or ''

local cacheKey = 'reddit_'..reddit

if cache.isCached(cacheKey) then
  cache.print(cacheKey)
  return
end

if #reddit > 0 then
  reddit = '/r/'..urlEncode(reddit)
end

local data, err = httpGet('http://reddit.com/'..reddit..'.json?limit=4')
if not data and err then
  etc.printf('$BError:$B %s', err)
  return
end

if data:sub(1, 1) ~= '{' then
  etc.printf('$BError:$B The subreddit you requested likely does not exist (invalid JSON reply).')
  return
end

-- sleep(1.1)

local parsed = json.decode(data)
if parsed.error then
  etc.printf('$BError:$B API error code %d', parsed.error)
  return
end

local urls = {}
for k, link in ipairs(parsed.data.children) do
  -- urls[#urls+1] = 'http://reddit.com'..link.data.permalink
  -- urls[#urls+1] = link.data.url
  if link.data.name then
    local newlink = 'http://redd.it/'..link.data.name:match("^.._(.*)$")
    link.data.newlink = newlink
    urls[#urls+1] = 'http://redd.it/'..link.data.name:match("^.._(.*)$")
  else
    local newlink = 'http://reddit.com'..link.data.permalink
    link.data.newlink = newlink
    urls[#urls+1] = newlink
  end
  -- urls[#urls+1] = 
end

-- local ret = etc.shortenurl(urls)
local ret = {}
for i = 1, #urls do
  ret[#ret + 1] = { url = urls[i], short = urls[i] }
end

cache.start(cacheKey, 15 * 60)
for k, link in ipairs(parsed.data.children) do
  local nsfw = ''
  if link.data.over_18 then
    nsfw = '\002\00304[NSFW]\003\002 '
  end
  link.data.title = link.data.title:gsub('\n', '')
  local s = ''
  if link.data.num_comments > 1 or link.data.num_comments == 0 then
    s = 's'
  end
  local tmp = stringx.fmtstr('%s(%d) /r/%s: $B%s$B: %s (submitted by %s, %d comment%s)', nsfw, link.data.score, link.data.subreddit or '?', link.data.title, link.data.newlink, link.data.author, link.data.num_comments, s)
  for k, url in pairs(ret) do
    if tmp and url.url and url.short then
      tmp = stringx.replace(tmp, url.url, url.short)
    else
      print('nil tmp', tmp, url.url, url.short)
    end
  end

  print(tmp)
end

cache.stop()
