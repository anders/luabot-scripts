local s = ""
for k, v in pairs(arg[1] or _G) do
    s = s .. k .. ", "
end
return s
