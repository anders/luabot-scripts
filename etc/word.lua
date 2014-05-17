if Editor then
  return
end
if not Cache.guess_word or not Cache.guess_word_phrase then
  Cache.guess_charge = nil
  Cache.guess_can_pass = nil
  local phrase
  if arg[1] then
    if type(arg[1]) == "function" then
      phrase = etc.getOutput(...)
    elseif type(arg[1]) == "string" and arg[1]:sub(1, 1) == "'" then
      local tick = arg[1]:sub(2)
      assert(not tick:find("[' ]"), "Not supported at the moment: " .. arg[1])
      assert(etc[tick], "etc." .. tick .. " ???")
      phrase = etc.getOutput(etc[tick]);
      assert(phrase and phrase:len() > 0, "There's no output")
    else
      -- assert(false, "Not sure what you want")
    end
  else
  end
  if not phrase then
    -- phrase = etc.getOutput(pickone{etc.qdb, etc.wikiquote})
    -- phrase = etc.rdef()
    local ap, bp = etc.randomDefinition(nil, 4, 250)
    phrase = bp
    Cache.guess_charge = true
  end
  assert(phrase and phrase:len() > 0, "There's no output")
  if phrase:len() > 200 then
    phrase = etc.wordcrop(phrase, 200)
  end
  phrase = phrase:gsub("%*", " ") -- Get rid of confusing stars.
  local word
  local n = 0
  for w in phrase:gmatch("%f[%w]([%w][%w%-][%w%-][%w%-]+)") do
    n = n + 1
    if not word then
      word = w
    end
    -- Too short, too long, or has uppercase (e.g. a Name) = lower probability.
    if (w:len() <= 4 or w:len() >= 9 or w:find("[A-Z]")) and 1 == math.random(1, 2) then
    else
      local wl = w:lower()
      if wl ~= "today" and wl ~= "fml" and wl ~= "then" and wl ~= "them" and wl ~= "they" then
        if 1 == math.random(1, n) then
          word = w
        end
      end
    end
  end
  assert(word, "lol word not found, try again: " .. phrase)
  -- local masked = ("*"):rep(word:len())
  local masked = word:gsub("[A-Za-z]", "*")
  phrase = phrase:gsub("%f[%w]" .. word .. "%f[^%w%-]", masked)
  Cache.guess_word_phrase = phrase
  Cache.guess_word = word
  Cache.guess_word_tries = 0
  print("The game is 'Guess The Word', guess ***... from the following using 'word <guess>:")
  -- print('Guess the ' .. word:len() .. ' letter word: "' .. phrase .. '"');
  print('Guess the word from: "' .. phrase:gsub("%*+", "***...") .. '"');
  
  if arg[1] ~= "-nohint" then
    sleep(10)
    if Cache.guess_word == word and not Cache.guess_can_pass then
      -- print('Word hint: ' .. Cache.guess_word:sub(1, 2) .. ("*"):rep(Cache.guess_word:len() - 2))
      print('Word hint: '
        .. Cache.guess_word:sub(1, 1) .. ("*"):rep(Cache.guess_word:len() - 1)
        .. " (" .. word:len() .. " letters) (use 'word'hint for a better hint)"
        )
    end
  end
  
else
  if arg[1] and arg[1]:len() > 0 then
    if arg[1] == "'hint" then
      local aa = ""
      if Cache.guess_charge then
       ----- ucashGive(-50, nick)
       ----- aa = " (-50)"
      end
      local hintmsg = 'Word hint: ' .. Cache.guess_word:sub(1, 2)
        .. ("*"):rep(Cache.guess_word:len() - 2 - 2)
        .. Cache.guess_word:sub(-2)
        .. " (" .. Cache.guess_word:len() .. " letters)"
      sendNotice(nick, hintmsg .. aa .. " (use 'word'pass to skip this word)")
      Cache.guess_can_pass = nick
      local ww = Cache.guess_word
      sleep(3)
      if ww == Cache.guess_word then
        print(hintmsg)
      end
      return
    elseif arg[1] == "'pass" then
      if Cache.guess_can_pass == nick then
        sendNotice(nick, "Passing in a few seconds, please wait...")
        local ww = Cache.guess_word
        sleep(10)
        if ww == Cache.guess_word then
          print("Giving up, the word was: " .. ww)
          Cache.guess_word = nil
        end
      else
        print("Cannot pass, use 'word'hint first")
      end
      return
    end
    assert(arg[1]:sub(1, 1) ~= "'", "Don't use " .. arg[1] .. " when guessing a word")
    if arg[1]:lower() == Cache.guess_word:lower() then
      local af = ""
      if Cache.guess_charge then
        ----- ucashGive(100, nick)
        ----- af = " (+100)"
      end
      print(nick .. " * Correct! The word was: " .. Cache.guess_word .. af)
      Cache.guess_word = nil
      Cache.guess_word_phrase = nil
      Cache.guess_can_pass = nil
    else
      local maxtries = 4
      local sofar = (Cache.guess_word_tries or 0) + 1
      Cache.guess_word_tries = sofar
      if sofar >= maxtries then
        print(nick .. " * Sorry, you lose, the word was: " .. Cache.guess_word)
        Cache.guess_word = nil
        Cache.guess_word_phrase = nil
      --[[elseif arg[1]:len() ~= Cache.guess_word:len() then
        local wn = Cache.guess_word:len()
        print(nick .. " * I'm looking for a " .. wn .. " letter word, like " .. etc.funword(wn))
        Cache.guess_word_tries = sofar - 1
      --]]
      else
        local hint = ""
        if sofar >= 2 then
          local lhn = math.random(3, Cache.guess_word:len())
          local lh = Cache.guess_word:sub(lhn, lhn)
          hint = "; one letter is '" .. lh .. "'"
        end
        local ab = ""
        if Cache.guess_charge then
          ----- ucashGive(-25, nick)
          ----- ab = " (-25)"
        end
        print(nick .. " * Nope, try again" .. ab .. " (" .. (maxtries - sofar) .. " more tries" .. hint .. ")")
      end
    end
  else
    -- print('Guess the ' .. Cache.guess_word:len() .. ' letter word: "' .. Cache.guess_word_phrase .. '"');
    print('Guess the word from: "' .. Cache.guess_word_phrase:gsub("%*+", "****") .. '"');
  end
end

