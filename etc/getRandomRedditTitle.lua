API "1.1"

-- Based on xt's >joke code for lorelai.

require "json"

local function pick(data)
  children = data.data.children
  thejoke = children[math.random(#children)]
  title = thejoke.data.title
  joketext = title .. ' ' .. thejoke.data.selftext
  return joketext
end

local function joke(subreddit, limit)
  local data = httpGet("http://www.reddit.com/r/" .. subreddit
    .. ".json?sort=random&limit=" .. limit)
  data = json.decode(data)
  -- try to find a short joke
  for i = 0, limit do
    local joketext = pick(data)
    if #joketext < 300 and #joketext > 5 then
      return joketext
    end
  end
end

local result = joke(assert(arg[1], 'subreddit expected'), arg[2] or 10) or 'not funny'
if arg[3] ~= '-preserve' then
  result = etc.cram(result, ". "):gsub(" *([%.!%?,]) *%. *", "%1 "):gsub("[%. !%?,]+$", ".")
end
return result
