return "\2"..arg[1]:gsub("\2", ""):gsub("\n", "\n\2"):gsub("\n\2$", "\n")
