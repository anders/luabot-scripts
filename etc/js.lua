local f = io.open(nick..'.js', 'w')
f:write(arg[1])
f:close()

if not Cache[nick..'js'] or Cache[nick..'js'] + 512 < os.time() then
  Cache[nick..'js'] = os.time()
  sendNotice(nick, 'open '..boturl..'u/anders/js.lua?u='..urlEncode(nick))
end
