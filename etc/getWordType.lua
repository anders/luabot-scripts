API "1.1"
-- Usage: etc.getWordType(word) returns the likely word type, along with the percent likelihood of this being true. Warning: this is very poorly or not implemented!

local w = ...

local t = {
  { "determiner", etc.isDeterminer, },
  { "pronoun", etc.isPronoun, },
  { "adverb", etc.isAdverb, },
  { "adjective", etc.isAdjective, },
  { "preposition", etc.isPreposition, },
  { "verb", etc.isVerb, },
  { "noun", etc.isNoun, },
}

local highestType = "none"
local highestScore = 0

for i = 1, #t do
  local x = t[i][2](w, true)
  if x >= highestScore then
    highestScore = x
    highestType = t[i][1]
  end
end

return highestType, highestScore
