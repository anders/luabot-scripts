
return etc.view(...)


--[[ -- Old:
local etcname = arg[1] or ""

if not etc[etcname] then
  print('etc.' .. etcname .. ' does not exist');
  return
end

print(boturl .. "view?module=etc&name=" .. etcname)
--]]

