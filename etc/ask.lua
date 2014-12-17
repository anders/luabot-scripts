API "1.1"

local LOG = plugin.log(_funcname);

local sub = pickone(arg[1] or { 'askreddit', 'askscience', 'shittyaskscience', 'askmen',
    'askwomen', 'doesanybodyelse', 'AskSocialScience', 'AskRedditAfterDark',
    }
  )
LOG.info("sub: " .. sub)

local x, y = etc.getRandomRedditTitle(sub)
if not x then
  return x, y
end
x = x:gsub("%[[^%]]*%] *", "")
x = x:gsub("DAE", "does anybody else")
x = x:gsub("[Ss]ubreddit", "channel")
x = x:gsub("[Tt]his [Ss]ub", "this channel")
x = x:gsub("[Rr]eddit", dest)
return x
