local allowChans = { ["#dbot"] = true }

if allowChans[dest] then
  assert(_setTopic(arg[1]))
  return dest, "topic set"
else
  return false, "Permission denied"
end
