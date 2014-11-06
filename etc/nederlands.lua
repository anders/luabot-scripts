return etc.je(arg[1]
  :gsub("[aeouAEOU]", function (x) return x .. x end)
  :gsub("y", "g")
  :gsub("Y", "G")
  :gsub("f", "v")
  :gsub("f", "V"))
or ""
