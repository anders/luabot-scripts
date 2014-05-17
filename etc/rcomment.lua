-- Usage: 'rc

-- http://www.reddit.com/dev/api#GET_hot
-- http://www.reddit.com/dev/api#GET_{sort}
-- http://www.reddit.com/dev/api#GET_comments_{article}

local json = require'json'

local rsort = pickone{"hot", "controversial", "top"}

local rurl = "http://www.reddit.com/r/AskReddit/" .. rsort .. "/"

print(httpGet(rurl .. ".json"))

print("not implemented")
