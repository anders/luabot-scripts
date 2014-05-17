local q = assert(arg[1], "Argument expected")
local callback = arg[2] or function(s, err)
    if s then
        print(s)
    else
        print(nick .. " * " .. err)
    end
end
local url = "http://www.google.com/search?ie=UTF-8&hl=en&num=1&q="
return httpGet(url .. urlEncode(q), function(data, err)
    if not data then
        callback(nil, (err or "Some sort of error"))
        return
    else
        local i, j
        i = data:find("<body[^%w%-]")
        if i then
            data = data:sub(i)
        end
        i, j = data:find("<img[^>]-src=[^>]-images[^>]-calc[^>]+>")
        if not j then
            i, j = data:find("class=\"currency[^>]*>.-<h3[^>]*>")
        end
        if j then
            data = data:sub(j + 1)
            i = data:find("<div", 1, true)
            if i then
                data = data:sub(1, i - 1)
                data = data:gsub("&nbsp;", " ")
                data = data:gsub("&#215;", "*")
                data = data:gsub("<sup>(.-)</sup>", function(sup)
                    if sup:find("%W") then
                        return "^(" .. sup .. ")"
                    else
                        return "^" .. sup
                    end
                end)
                callback(html2text(data))
                return
            end
        end
    end
    callback(nil, "Unable to evaluate")
end)
