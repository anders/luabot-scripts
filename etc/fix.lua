if etc.on_msg then
  Event = {
    msg = arg[1] or LocalCache.lastmsg,
    nick = arg[1] and nick or LocalCache.lastmsgnick,
  }
  return etc.on_msg(...)
end
