API "1.1"

local level -- 0 through 1, 1 = 100%

if arg[1] then
  local f = etc.parseFunc(arg[1])
  if f then
    local code = getCode(f)
    if code then
      local a = math.min(#code / (1024 * 2), 1)
      local b = math.min((etc.countOccurences("for", code) +
        etc.countOccurences("while", code) +
        etc.countOccurences("until", code)) / 50, 1)
      level = a / 2 + b / 2
    end
  end
end
if not level then
  local a = arg[1] or nick
  level = (math.floor(os.time() / 1000) % 771 / 770) / 2 + (#a % 7 / 6) / 2
end

local width = 25
local bars = math.floor(width * level + 0.5)
local spacing = width - bars

local words_of_wisdom = "?"
if level <= 0.25 then
  words_of_wisdom = "mild"
elseif level <= 0.50 then
  words_of_wisdom = "average"
elseif level <= 0.75 then
  words_of_wisdom = "elevated"
elseif level <= 0.90 then
  words_of_wisdom = "extreme"
else
  words_of_wisdom = "totally"
end
return "[" .. ("="):rep(bars) .. (" "):rep(spacing) .. "]",
  etc.getOutput(etc.trfunny, words_of_wisdom)
