if LocalCache.on_cmd == 1 then
  return etc.on_cmd_1(...)
else
  return etc.on_cmd_2(...)
end
