-- Usage: 'topic to get or append to the topic, include -s to set without append.

if not arg[1] then
  return topic(dest) or ''
end

assert(Cache.topicid ~= _threadid, "It doesn't work that way")
Cache.topicid = _threadid

local allowChans = { ["#dbot"] = true }

if allowChans[dest] then
  local newtopic = arg[1]
  if newtopic:find("^%-s ") then
    newtopic = newtopic:sub(4)
  else
    local prev = topic(dest)
    if prev then
      newtopic = newtopic .. " | " .. prev
    end
  end
  assert(_setTopic(newtopic))
  singleprint()
  return dest, "topic set"
else
  return false, "Permission denied"
end
