local s = arg[1] or ''
s = s:gsub("rn", "m")
s = s:gsub("[co]l", "d")
s = s:gsub("l[co]", "b")
s = s:gsub(".", function(c)
  if c == ' ' then
    if math.random() < 0.25 then
      return ""
    end
  end
  if math.random() < 0.05 then
    return c .. " "
  end
  if c == 'd' then
    if math.random() < 0.25 then
      return "ol"
    end
  end
  if c == 'b' then
    if math.random() < 0.25 then
      return "lo"
    end
  end
  if c == 'm' then
    if math.random() < 0.25 then
      return "rn"
    end
  end
end)
return s
