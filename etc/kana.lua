local Hiragana = {
   a = 'あ',   i = 'い',   u = 'う',  e = 'え',  o = 'お',
  ka = 'か',  ki = 'き',  ku = 'く', ke = 'け', ko = 'こ',
  sa = 'さ', shi = 'し',  su = 'す', se = 'せ', so = 'そ',
  ta = 'た', chi = 'ち', tsu = 'つ', te = 'て', to = 'と',
  na = 'な',  ni = 'に',  nu = 'ぬ', ne = 'ね', no = 'の',
  ha = 'は',  hi = 'ひ',  fu = 'ふ', he = 'へ', ho = 'ほ',
  ma = 'ま',  mi = 'み',  mu = 'む', me = 'め', mo = 'も',
  ya = 'や',              yu = 'ゆ',           yo = 'よ',
  ra = 'ら',  ri = 'り',  ru = 'る', re = 'れ', ro = 'ろ',
  wa = 'わ',                                   wo = 'を',
   n = 'ん'
}

local Katakana = {
   a = 'ア',   i = 'イ',   u = 'ウ',  e = 'エ',  o = 'オ',
  ka = 'カ',  ki = 'キ',  ku = 'ク', ke = 'ケ', ko = 'コ',
  sa = 'サ', shi = 'シ',  su = 'ス', se = 'セ', so = 'ソ',
  ta = 'タ', chi = 'チ', tsu = 'ツ', te = 'テ', to = 'ト',
  na = 'ナ',  ni = 'ニ',  nu = 'ヌ', ne = 'ネ', no = 'ノ',
  ha = 'ハ',  hi = 'ヒ',  fu = 'フ', he = 'ヘ', ho = 'ホ',
  ma = 'マ',  mi = 'ミ',  mu = 'ム', me = 'メ', mo = 'モ',
  ya = 'ヤ',              yu = 'ユ',           yo = 'ヨ',
  ra = 'ラ',  ri = 'リ',  ru = 'ル', re = 'レ', ro = 'ロ',
  wa = 'ワ',                                   wo = 'ヲ',
   n = 'ン'
}

local KanaT = {}
for romaji, kana in pairs(Hiragana) do
  KanaT[#KanaT+1] = {romaji=romaji, kana=kana}
end

for romaji, kana in pairs(Katakana) do
  KanaT[#KanaT+1] = {romaji=romaji, kana=kana}
end

local correct_cache = 'kana_correct_'..nick
local correct = Cache[correct_cache] or 0
local wrong_cache = 'kana_wrong_'..nick
local wrong = Cache[wrong_cache] or 0
local current_cache = 'kana_current_'..nick
local current = Cache[current_cache] or math.random(1, #KanaT)
Cache[current_cache] = current
local K = KanaT[current]

function newKana()
  current = math.random(1, #KanaT)
  Cache[current_cache] = current
  K = KanaT[current]
end

if not arg[1] then
  etc.printf("Current: %s", K.kana)
else
  if arg[1] == K.romaji then
    correct = correct + 1
    Cache[correct_cache] = correct
    Cache[current_cache] = nil
    newKana()
    etc.printf("Correct! %d correct, %d wrong. Now try: %s", correct, wrong, K.kana)
  else
    wrong = wrong + 1
    Cache[wrong_cache] = wrong
    Cache[current_cache] = nil
    local romaji = K.romaji
    newKana()
    etc.printf("Wrong! You meant: %s. %d correct, %d wrong. Now try: %s", romaji, correct, wrong, K.kana)
  end
end