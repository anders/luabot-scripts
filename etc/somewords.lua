API "1.1"
-- Usage: 'somewords some text to replace some words. Rated R.

return etc.translateWords(arg[1], function(w)
  if etc.isReplaceWord(w) then
    return etc.someword()
  end
end)
