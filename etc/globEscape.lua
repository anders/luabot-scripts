-- Helper function for os.glob to escape any glob characters.
local x = (arg[1] or ""):gsub("[%[%]%?%*\\]", "\\%1")
return x