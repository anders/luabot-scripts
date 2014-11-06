API "1.1"

return etc.fullwidth(etc.translateWords(arg[1] or '', function(s)
  local c = math.floor(math.random() * (0x9FCC - 0x4E00)) + 0x4E00
  return html2text(string.format("&#x%x;", c))
end):gsub(" ", ""):gsub("%.", "。"))
