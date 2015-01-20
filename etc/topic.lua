-- Usage: 'topic to get or append to the topic, use -s to set without append. Other switches: -r [<n>] to remove a part, -c to clear, -u to undo.

if not arg[1] then
  return topic(dest) or ''
end

assert(Cache.topicid ~= _threadid, "It doesn't work that way")
Cache.topicid = _threadid

local allowChans = { ["#dbot"] = true }

if allowChans[dest] then
  local oldtopic = topic(dest) or ''
  local opt, after = arg[1]:match("^%-(.) ?(.*)$")
  local newtopic = after or arg[1]
  if opt == "s" then
    -- Set the entire topic.
  elseif opt == "r" then
    -- Remove a part of the topic, defaults to 1 (1 appears first, the last added)
    local nr = tonumber(after) or 1
    local tparts = etc.splitByPattern(oldtopic, " %| ")
    table.remove(tparts, nr)
    newtopic = table.concat(tparts, " | ")
  elseif opt == "u" then
    -- Topic undo.
    newtopic = assert(LocalCache.oldtopic, "No topic")
    LocalCache.oldtopic = nil
  elseif opt == "c" then
    -- Topic clear.
    newtopic = ''
  else
    assert(opt == nil, "What is -" .. (opt or "?"))
    if oldtopic ~= '' then
      newtopic = newtopic .. " | " .. oldtopic
    end
  end
  assert(_setTopic(newtopic))
  if oldtopic ~= '' then
    LocalCache.oldtopic = oldtopic
  end
  -- singleprint()
  -- return dest, "topic set"
  return true -- ok
else
  return false, "Permission denied"
end
