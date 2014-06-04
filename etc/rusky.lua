function oneOf(options)
  return function ()
    return options[math.floor(math.random() * #options) + 1]
  end
end

return (arg[1]:upper()
  :gsub("[Aa]", oneOf({"Д"}))
  :gsub("[Bb]", oneOf({"Ь", "Ъ", "Б"}))
  :gsub("[Ee]", oneOf({"З", "Э"}))
  :gsub("[Kk]", oneOf({"К"}))
  :gsub("[Nn]", oneOf({"И", "Й"}))
  :gsub("[Oo]", oneOf({"Ф"}))
  :gsub("[Rr]", oneOf({"Я"}))
  :gsub("[Uu]", oneOf({"Ц"}))
  :gsub("[Ww]", oneOf({"Ш", "Щ"}))
  :gsub("[Xx]", oneOf({"Ж"}))
  :gsub("[Yy]", oneOf({"У", "Ч"})));