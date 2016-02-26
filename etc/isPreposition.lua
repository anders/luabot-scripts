API "1.1"
-- Usage: etc.isPreposition(word, wantScore) - this is not really implemented!

local w, wantScore = ...

local t = {
  aboard=1,
  about=1,
  above=1,
  across=1,
  after=1,
  against=1,
  along=1,
  amid=1,
  among=1,
  anti=1,
  around=1,
  as=1,
  at=1,
  before=1,
  behind=1,
  below=1,
  beneath=1,
  beside=1,
  besides=1,
  between=1,
  beyond=1,
  but=1,
  by=1,
  concerning=1,
  considering=1,
  despite=1,
  down=1,
  during=1,
  except=1,
  excepting=1,
  excluding=1,
  following=1,
  ["for"]=1,
  from=1,
  ["in"]=1,
  inside=1,
  into=1,
  like=1,
  minus=1,
  near=1,
  of=1,
  off=1,
  on=1,
  onto=1,
  opposite=1,
  outside=1,
  over=1,
  past=1,
  per=1,
  plus=1,
  regarding=1,
  round=1,
  save=1,
  since=1,
  than=1,
  through=1,
  to=1,
  toward=1,
  towards=1,
  under=1,
  underneath=1,
  unlike=1,
  ["until"]=1,
  up=1,
  upon=1,
  versus=1,
  via=1,
  with=1,
  within=1,
  without=1,
}

local score = t[w] or 0
if wantScore then
  return score
else
  return score >= 0.75
end