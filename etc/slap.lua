local settings = plugin.settings(io)

local target = arg[1] or nick

local butts = settings.load('butts')

if butts[target] and not butts[nick] then
    print("only butts can slap other butts")
else
    action("slaps " .. target)
end