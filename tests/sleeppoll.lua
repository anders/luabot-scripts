if Web then error('no') end

function check()
  if Cache.sleeptest then
    local x = Cache.sleeptest
    Cache.sleeptest = nil
    return x
  end

  return false
end

print('polling... do \'run Cache.sleeptest=1337')
while true do
  local var = check()
  if var then
    print('got '..tostring(var))
    break
  end
  pcall(sleep, 3)
end
