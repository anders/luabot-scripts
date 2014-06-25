API "1.1"

local quote = assert(httpGet("http://www.iheartquotes.com/api/v1/random"))

return html2text((quote:match("(.-)%[%w+%]")))

