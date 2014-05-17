local settings = plugin.settings(io)

if not arg[1] then
    print("Usage: " .. etc.cmdchar .. "demotebutt <target>")
    return nil
end

local butts = settings.load('butts')

if not butts[nick:lower()] then
    print("You're not a butt, try again when you are one")
    return nil
end

arg[1] = arg[1]:lower()

if arg[1] == "q66" or arg[1] == "q66[mac]" or arg[1] == "wm4" then
    print("How dare you!")
    return nil
end

butts[arg[1]] = nil

settings.save('butts', butts)

print('Done.')
