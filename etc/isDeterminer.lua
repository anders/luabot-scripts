API "1.1"
-- Usage: etc.isDeterminer(word, wantScore) - note that this is guess and may be wrong.

local w, wantScore = ...

local t = {
  -- a few
  fewer = 1,
  fewest = 1,
  every = 1,
  most = 1,
  that = 1,
  -- a little
  half = 1,
  much = 1,
  the = 1,
  -- an other
  another = 1,
  her = 1,
  my = 1,
  their = 1,
  a = 1,
  an = 1,
  his = 1,
  neither = 1,
  these = 1,
  all = 1,
  its = 1,
  no = 1,
  this = 1,
  any = 1,
  those = 1,
  both = 1,
  least = 1,
  our = 1,
  what = 1,
  each = 1,
  less = 1,
  several = 1,
  which = 1,
  either = 1,
  many = 1,
  some = 1,
  whose = 1,
  enough = 1,
  more = 1,
  such = 1,
  your = 1,
  
  zero = 0.9,
  one = 0.9,
  four = 0.9,
  ten = 0.9,
  eleven = 0.9,
  twelve = 0.9,
  thirteen = 0.9,
  fourteen = 0.9,
  fifteen = 0.9,
  sixteen = 0.9,
  seventeen = 0.9,
  eighteen = 0.9,
  nineteen = 0.9,
}

local score = t[w] or 0

if score == 0 and w and type(w) == "string" then
  if w:find("'s$") then
    score = 0.8
  elseif w:find("^%d*%.%d+$") then
    score = 0.9
  elseif w:find("%-one$") then
    score = 0.9
  elseif w:find("two$") then
    score = 0.9
  elseif w:find("three$") then
    score = 0.9
  elseif w:find("%-four$") then
    score = 0.9
  elseif w:find("five$") then
    score = 0.9
  elseif w:find("six$") then
    score = 0.9
  elseif w:find("seven$") then
    score = 0.9
  elseif w:find("eight$") then
    score = 0.9
  elseif w:find("nine$") then
    score = 0.9
  elseif w:find("^twenty") then
    score = 0.9
  elseif w:find("^thirty") then
    score = 0.9
  elseif w:find("^forty") then
    score = 0.9
  elseif w:find("^fifty") then
    score = 0.9
  elseif w:find("^sixty") then
    score = 0.9
  elseif w:find("^seventy") then
    score = 0.9
  elseif w:find("^eighty") then
    score = 0.9
  elseif w:find("^ninety") then
    score = 0.9
  elseif w:find("hundred$") then
    score = 0.9
  elseif w:find("thousand$") then
    score = 0.9
  elseif w:find("million$") then
    score = 0.9
  elseif w:find("billion$") then
    score = 0.9
  end
end

if wantScore then
  return score
else
  return score >= 0.75
end
