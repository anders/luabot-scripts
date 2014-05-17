if account == 2 then
  return 'uid=0(root) gid=0(root) groups=0(root)'
else
  return ('uid=%d(%s) gid=%d(%s) groups=1000(users)'):format(account, getname(account), account, getname(account))
end
