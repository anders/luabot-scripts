-- A work in progress. Feel free to finish it

function exc(s, ...) print('Error: '..s:format(...)) end
function pf(s, ...) print(s:format(...)) end

if #arg < 1 then
  return exc('%s', 'Usage: \\hangman <help|guess|show> [word|letter]\nUse /msg '..bot..' /run etc.hangman("start", "word") to start a new game')
end

if arg[1] == 'start' and #arg == 2 then
  Cache.hangman_word = arg[2]:lower()
  return pf('Word set to "%s", use \\hangman start in the channel now', Cache.hangman_word)
end

-- assume it's \hangman
if #arg == 1 then
  if not Cache.hangman_word then
    return exc('No game in progress. Please /msg %s /run etc.hangman("start", "word") to start a new game', bot)
  end

  if arg[1] == 'start' then
    print('Hangman game in progress!')
  end
end