API "1.1"
-- Usage: etc.Noun(word, wantScore) - this is not really implemented!

local w, wantScore = ...

local t = {
  time=1,
  year=1,
  people=1,
  way=1,
  day=1,
  man=1,
  thing=1,
  woman=1,
  life=1,
  child=1,
  world=1,
  school=1,
  state=1,
  family=1,
  student=1,
  group=1,
  country=1,
  problem=1,
  hand=1,
  part=1,
  place=1,
  case=1,
  week=1,
  company=1,
  system=1,
  program=1,
  question=1,
  work=1,
  government=1,
  number=1,
  night=1,
  point=1,
  home=1,
  water=1,
  room=1,
  mother=1,
  area=1,
  money=1,
  story=1,
  fact=1,
  month=1,
  lot=1,
  right=1,
  study=1,
  book=1,
  eye=1,
  job=1,
  word=1,
  business=1,
  issue=1,
  side=1,
  kind=1,
  head=1,
  house=1,
  service=1,
  friend=1,
  father=1,
  power=1,
  hour=1,
  game=1,
  line=1,
  ["end"]=1,
  member=1,
  law=1,
  car=1,
  city=1,
  community=1,
  name=1,
  president=1,
  team=1,
  minute=1,
  idea=1,
  kid=1,
  body=1,
  information=1,
  back=1,
  parent=1,
  face=1,
  others=1,
  level=1,
  office=1,
  door=1,
  health=1,
  person=1,
  art=1,
  war=1,
  history=1,
  party=1,
  result=1,
  change=1,
  morning=1,
  reason=1,
  research=1,
  girl=1,
  guy=1,
  moment=1,
  air=1,
  teacher=1,
  force=1,
  education=1,
}

local score = t[w] or 0

if score == 0 and w and type(w) == "string" then
  -- huge guess:
  local x = math.max(etc.isVerb(w, true), etc.isDeterminer(w, true), etc.isAdverb(w, true), etc.isPronoun(w, true))
  if x >= 0.5 then
    score = 1.0 - x
  else
    score = x
  end
end

if wantScore then
  return score
else
  return score >= 0.75
end
