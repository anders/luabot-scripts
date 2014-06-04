if not arg[1] then
  return etc.lastlog()
end
return etc.debuglog(...)
