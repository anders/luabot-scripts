return etc.getOutput(etc.je, ...)
  :gsub("[aeouAEOU]", function (x) return x .. x end)
  :gsub("y", "g")
  :gsub("Y", "G")
  :gsub("f", "v")
  :gsub("f", "V")
or ""
