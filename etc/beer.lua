local st = "site:www.beeradvocate.com " .. assert(arg[1], 'what beer? or are you durnk?')
local gresult = assert(etc.getOutput(etc.google, st))
local url = etc.firsturl(gresult)

local page = httpGet(url)

local a = page:find("<b>Brewed by:</b>", 1, true)
if a then
  page = page:sub(a)
end

local b = page:find("</table>")
if b then
  page = page:sub(1, b - 1)
end

page = page:gsub("<br>", " | ")

return html2text(page)
