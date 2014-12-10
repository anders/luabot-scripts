API "1.1"

if not LocalCache.lastmsg then
  return "<" .. nick .. ">", "u"
end

return "<U>", etc.str_replace(LocalCache.lastmsg, nick, LocalCache.lastmsgnick)
