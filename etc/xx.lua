local s = arg[1] or ""
local slen = s:len()
local c = math.floor(math.max(slen / 19, 3))
local slang = {
  "butt", "ass", "anus", "pussy", "penis", "vagina",
}
return (s:gsub("[a-zA-Z'%-]+", function(x)
  if x:len() >= 4 and math.random(1, c) == 1 then
    c = math.floor(math.max(slen / 19, 3))
    return slang[math.random(#slang)]
  end
  c = math.max(c - 1, 3)
  return x
end))
