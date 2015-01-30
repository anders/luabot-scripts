API "1.1"
-- Usage: 'choose this or that

if not arg[1] or arg[1] == "" then
  return false, 'What or what?'
end

local splitter = "[ ,%.!%?%|]+"
if arg[1]:find("%|") then
  splitter = " *%|+ *"
elseif arg[1]:find(" [oO][rR] ") then
  splitter = " +[oO][rR] +"
end

return pickone(etc.splitByPattern(arg[1], splitter))
