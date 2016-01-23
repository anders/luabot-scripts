API "1.1"
-- Usage: etc.isAdverb(word, wantScore) - note that this is a huge guess and may be wrong!

local w, wantScore = ...

local t = {
  again=1,
  ahead=1,
  already=1,
  almost=1,
  always=1,
  also=1,
  altogether=1,
  anyway=1,
  as=1,
  ["else"]=1,
  elsewhere=1,
  ever=1,
  everywhere=1,
  forth=1,
  how=1,
  however=1,
  instead=1,
  moreover=1,
  never=1,
  ["not"]=1,
  often=1,
  only=1,
  out=1,
  rather=1,
  seldom=1,
  so=1,
  sometimes=1,
  soon=1,
  there=1,
  therefore=1,
  thus=1,
  together=1,
  too=1,
  twice=1,
  up=1,
  very=1,
  when=1,
  seldom=1,
  well=1,
  henceforth=1,
  regardless=1,
}

local score = t[w] or 0

if score == 0 and w and type(w) == "string" then
  if #w >= 4 and w:find("ly$") then
    score = 0.75
  end
end

if wantScore then
  return score
else
  return score >= 0.75
end
