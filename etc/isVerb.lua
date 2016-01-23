API "1.1"
-- Usage: etc.isVerb(word, wantScore) - this is not really implemented!

local w, wantScore = ...

local t = {
  be=1,
  have=1,
  ["do"]=1,
  say=1,
  go=1,
  can=1,
  get=1,
  would=1,
  make=1,
  know=1,
  will=1,
  think=1,
  take=1,
  see=1,
  come=1,
  could=1,
  want=1,
  look=1,
  use=1,
  find=1,
  give=1,
  tell=1,
  work=1,
  may=1,
  should=1,
  call=1,
  try=1,
  ask=1,
  need=1,
  feel=1,
  become=1,
  leave=1,
  put=1,
  mean=1,
  keep=1,
  let=1,
  begin=1,
  seem=1,
  help=1,
  talk=1,
  turn=1,
  start=1,
  might=1,
  show=1,
  hear=1,
  play=1,
  run=1,
  move=1,
  like=1,
  live=1,
  believe=1,
  hold=1,
  bring=1,
  happen=1,
  must=1,
  write=1,
  provide=1,
  sit=1,
  stand=1,
  lose=1,
  pay=1,
  meet=1,
  include=1,
  continue=1,
  set=1,
  learn=1,
  change=1,
  lead=1,
  understand=1,
  watch=1,
  follow=1,
  stop=1,
  create=1,
  speak=1,
  read=1,
  allow=1,
  add=1,
  spend=1,
  grow=1,
  open=1,
  walk=1,
  win=1,
  offer=1,
  remember=1,
  love=1,
  consider=1,
  appear=1,
  buy=1,
  wait=1,
  serve=1,
  die=1,
  send=1,
  expect=1,
  build=1,
  stay=1,
  fall=1,
  cut=1,
  reach=1,
  kill=1,
  remain=1,
}

local score = t[w] or 0

if score == 0 and w and type(w) == "string" then
  -- huge guess:
  if w:find(".s$") then
    local wx = w:match("(.*)s$")
    score = t[wx] and (t[wx] / 10 * 9) or 0.25
  elseif w:find(".ed$") then
    local wx1, wx2 = w:match("^((.*).)ed$")
    score = (t[wx1] or t[wx2] or 0.8) / 5 * 4
  else
    score = 0.25 -- not even going to try, but it could be a verb...
  end
end

if wantScore then
  return score
else
  return score >= 0.75
end
