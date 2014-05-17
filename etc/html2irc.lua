local s = arg[1] or ""
s = s:gsub("<[/]?[bB]>", "\002")
s = s:gsub("<[/]?[sS][tT][rR][oO][nN][gG]>", "\002")
s = s:gsub("<[/]?[uU][lL]?>", "\031")

-- New:
s = s:gsub("<[Ii][Nn][Ss]>", "\0033\002\002")
s = s:gsub("</[Ii][Nn][Ss]>", "\003\002\002")
s = s:gsub("<[Dd][Ee][Ll]>", "\0034\002\002")
s = s:gsub("</[Dd][Ee][Ll]>", "\003\002\002")

s = html2text(s)
return s
