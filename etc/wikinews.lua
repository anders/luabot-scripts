-- http://en.wikinews.org/w/index.php?action=render&title=Main_Page

-- return etc.web("http://en.wikinews.org/w/index.php?action=render&title=Main_Page")

local data, err = httpGet("http://en.wikinews.org/w/index.php?action=render&title=Main_Page")
if data then
  local a = data:find('<span class="more_news">', 1, true)
  if a then
    data = data:sub(a)
  end
  local b = data:find('<li', 1, true)
  if b then
    data = data:sub(b)
  end
  if data:len() > 1024 * 24 then
    data = data:sub(1, 1024 * 24)
  end
  data = data:gsub("<li", "&bull; %1")
  data = data:gsub("</li>", "</li>~NL~")
end
local output = html2text(data or err):gsub("~NL~", "\n")
return output
