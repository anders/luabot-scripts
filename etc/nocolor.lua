API "1.1"

return arg[1]
  :gsub("\02", "")
  :gsub("\03%d%d?,%d%d?", "")
  :gsub("\03%d%d?", "")
  :gsub("\03", "")
  :gsub("\15", "") 
  :gsub("\17", "") 
  :gsub("\18", "") 
  :gsub("\22", "") 
  :gsub("\29", "") 
  :gsub("\31", "") or ""
