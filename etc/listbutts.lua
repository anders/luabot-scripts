local settings = plugin.settings(io)

local butts = settings.load('butts')

local list
for k, v in pairs(butts) do
    if v then list = not list and k or list .. ", " .. k end
end

print(list)