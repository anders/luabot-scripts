API "1.1"

local content = ...
assert(content and content.graphUrlPrefix, "Need content table at least with graphUrlPrefix")

local graphs = content.graphsArray or etc.munin_conf().plugins

local html = [[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>%title%</title>
%head%
</head><body>
%header%
<h4>%heading%</h4>
<table border="0">
%graphdo%
<tr>
  <td colspan="2"><div class="graphHead"><a href="%graphUrlPrefix%%graph%">%graph%</a>:</div></td>
</tr>
<tr>
  <td><a href="%graphUrlPrefix%%graph%"><img src="%graphImgPrefix%%graph%-day.png" alt="Daily %graph%" border="0"></a></td>
  <td><a href="%graphUrlPrefix%%graph%"><img src="%graphImgPrefix%%graph%-week.png" alt="Weekly %graph%" border="0"></a></td>
</tr>
%graphend%
</table>
%footer%
</body></html>
]]

local output = content.output or (Web and Web.write) or print

html = html:gsub("%%graphdo%%(.*)%%graphend%%", function(template)
  local t = {}
  for igraph, graph in ipairs(graphs) do
    t[#t + 1] = template:gsub("%%graph%%", graph)
  end
  return table.concat(t, "\n")
end)

output(html:gsub("%%([^%%]+)%%", function(x)
  if content[x] then
    return content[x]
  end
  if x == "title" then
    return "Graphs"
  elseif x == "heading" then
    return "Graphs"
  elseif x == "graphImgPrefix" then
    return boturl.."t/graphs/ludebot/"
  end
  return ""
end):gsub("%%%%", "%%") or "")
