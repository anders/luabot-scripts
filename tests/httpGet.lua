-- New way with blocking:
local data = assert(httpGet(arg[1] or "example.com"))
print(html2text(data))


--[[ -- The old way with a callback:
return httpGet(arg[1] or "example.com", function(data, err)
    assert(data, err)
    print(html2text(data))
end)
--]]
