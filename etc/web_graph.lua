API "1.1"

local graph, content = ...
assert(graph, "Which graph?")
content = content or {}

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
<tr>
  <td><img src="%graphImgPrefix%%graph%-day.png" alt="Daily" border="0"></td>
  <td><img src="%graphImgPrefix%%graph%-week.png" alt="Weekly" border="0"></td>
</tr>
<tr>
  <td><img src="%graphImgPrefix%%graph%-month.png" alt="Monthly" border="0"></td>
  <td><img src="%graphImgPrefix%%graph%-year.png" alt="Yearly" border="0"></td>
</tr>
%footer%
</body></html>
]]

local output = content.output or (Web and Web.write) or print

output(html:gsub("%%([^%%]+)%%", function(x)
  if x == "graph" then
    return graph
  end
  if content[x] then
    return content[x]
  end
  if x == "title" then
    return graph .. " graph"
  elseif x == "heading" then
    return "Graph for " .. graph
  elseif x == "graphImgPrefix" then
    return boturl.."t/graphs/ludebot/"
  end
  return ""
end):gsub("%%%%", "%%") or "")
