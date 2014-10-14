local map = {
  ["ɔː"]="o",
  ["ə"]="oo",
  ["ju"]="u",
  ["ʌ"]="uh",
  ["æ"]="ae",
  ["ɪ"]="ee",
  ["ð"]="th",
  ["ʊ"]="w",
  ["θ"]="th",
  ["ŋ"]="n",
  ["ʃ"]="shu",
  ["ː"]="ay",
  ["ʤ"]="dj",
  ["ː"]="",
  ["ɔ"]="oh",
  ["ɒ"]="ah",
  ["ɜ"]="i",
  ["ʧ"]="ch",
  ["ɑ"]="ah",
  ["j"]="y",
}

local arg = { etc.pronounce(...) }
if not arg[1] then
  return unpack(arg)
end
local s = arg[1]
for k, v in pairs(map) do
  s = s:gsub(k, v)
end
return s:gsub("eee", "ay") or ''
