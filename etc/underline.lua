return "\31"..arg[1]:gsub("\31", ""):gsub("\n", "\n\31"):gsub("\n\31$", "\n")
