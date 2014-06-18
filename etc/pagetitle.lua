local url = assert(arg[1], "URL expected")
local callback = arg[2] or function(s, err)
    if s then
        print(nick .. " * \"" .. s .. "\"")
    else
        print(nick .. " * " .. err)
    end
end
return httpGet(url, function(data, err)
    if not data then
        callback(nil, (err or "Some sort of error"))
        return
    else
        local t = data:match("<[tT][iI][tT][lL][eE]%s*>(.-)</[tT][iI][tT][lL][eE]%s*>")
        if t then
            t = html2text(t)
            callback(t)
            return
        end
    end
    callback(nil, "No title found")
end)
