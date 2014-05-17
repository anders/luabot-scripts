local function cb(m) print(m) end

-- to prevent errors
if Cache.guess_active then
  if not Cache.guess_started then Cache.guess_started = 0 end
end

if arg[1] == nil then
  if Cache.guess_active then
    local delta_time = os.time() - Cache.guess_started
    if delta_time < 60*2 then
      cb('guessing game is in progress already!')
      return
    end
  end
  
  Cache.guess_active = true
  Cache.guess_number = math.random(1, 1000)
  Cache.guess_attempts = 10
  Cache.guess_started = os.time()

  cb('guessing game started! guess using guess(number), from 1 to 1000')
else
  if not Cache.guess_active then
    cb('guessing game is not active! start it with guess(n). you have 10 tries to get it right!!!!!!!!!')
    return
  end

  local n = tonumber(arg[1])
  if not n or n < 0 or n > 1000 then
    cb('invalid number')
    return
  end
  
  if n == Cache.guess_number then
    cb('good job!')
    Cache.guess_active = false
    return
  else
    Cache.guess_attempts = Cache.guess_attempts - 1
    if Cache.guess_attempts < 1 then
      cb('you lost! the number was: '..Cache.guess_number)
      Cache.guess_active = false
    else
      local what = 'higher'
      if Cache.guess_number < n then what = 'lower' end
      cb('wrong number, '..Cache.guess_attempts..' attempts left. try a '..what..' number')
      return
    end
  end
end