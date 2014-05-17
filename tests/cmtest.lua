httpGet("www.example.com", function(data, err) print(nick, "*", getContentHtml(data or err)) end)
setTimeout("print('Timeout 1')", 1000)
setTimeout("print('Timeout 2')", 1000) -- Too much output
-- setTimeout("print('Timeout 3')", 1000)
return { hi = 42 }
