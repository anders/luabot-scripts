API "1.1"

return etc.fullwidth(etc.translateWords(arg[1] or '', function(s)
  local c = math.floor(math.random() * (0xD7AF - 0xAC00)) + 0xAC00
  return html2text(string.format("&#x%x;", c))
end):gsub(" ", ""):gsub("%.", "。"))
