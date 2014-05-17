-- Usage: 'a (again) run the last command again pls

-- print("test", LocalCache.lastcmd)

if LocalCache.lastcmd then
  if LocalCache.lastcmd:match("%w+") == 'a' then
    if not LocalCache.lastcmd2 then
      return
    end
    LocalCache.lastcmd = LocalCache.lastcmd2
    LocalCache.lastcmdnick = LocalCache.lastcmdnick2
  end
  LocalCache.lastcmd2 = LocalCache.lastcmd
  LocalCache.lastcmdnick2 = LocalCache.lastcmdnick
  return etc.cmd(LocalCache.lastcmd)
end
