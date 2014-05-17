local settings = plugin.settings(io)

if not arg[1] then
    print("Usage: " .. etc.cmdchar .. "makeabutt <target>")
    return nil
end

local butts = settings.load('butts')

if not butts[nick:lower()] then
    print("You're not a butt, try again when you are one")
    return nil
end

butts[arg[1]:lower()] = true

settings.save('butts', butts)

print('Done.')