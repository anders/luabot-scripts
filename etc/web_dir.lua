if type(arg[1]) ~= "table" or not arg[1].GET then
  error("Argument expected")
end

local Web = arg[1]
local fs

Web.write([==[<html><head>
<style>
  .fsparent { margin: 5px 0 5px 0; }
    .fsparent a { text-decoration: none; font-size: 14pt; }
</style>
<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
</head><body>
]==])

local p = Web.GET["p"]
local u = Web.GET["u"]

if not p or p == ""  then
  if not u or u == "" then
    Web.write([==[
  <form action="">
    User: <input name="u"><input type="submit">
  <form>
  ]==])
    return
  else
    p = "/"
    fs = getUserFS(u)
  end
else
  u, p = p:match("^/user/([^/]+)(/?.*)")
  if u then
    fs = getUserFS(u)
  end
end
assert(fs, "Invalid user")
if p == "" then
  p = "/"
end


local function fixText(s)
  return s:gsub("[&<>\"']", function(x)
    if x == '&' then
      return "&amp;"
    elseif x == '<' then
      return "&lt;"
    elseif x == '>' then
      return "&gt;"
    elseif x == '"' then
      return "&quot;"
    elseif x == "'" then
      return "&squot;"
    end
  end)
end


Web.write("<h3 id='dirname'>/user/" .. u .. p .. "</h3>\n")

do
  local up = ""
  local a, b = ("/user/" .. u .. p):match("^(.*)/[^/]+/?$")
  if a and a ~= "" and a ~= "/user" then
    up = fixText(a)
  end
  up = urlEncode(up):gsub("%%2F", "/")
  Web.write("<h5 class='fsparent'><a href='?p=" .. up .. "'>&larr;</a></h5>\n")
end

local ntotal = 0
fs.list(p, function(path, attribs)
  local name = path:match("/([^/]+)$")
  if not name then
    name = path
  end
  if attribs:find("d", 1, true) then
    local ul = urlEncode("/user/" .. u .. path):gsub("%%2F", "/")
    Web.write("<div class='fsnode fsdir'><a href='?p=" ..
      ul .. "'>" .. fixText(name) .. "</a></div>\n")
  else
    Web.write("<div class='fsnode fsfile'><a>" .. fixText(name) .. "</a></div>\n")
  end
  ntotal = ntotal + 1
end, "a")
Web.write("<br><div id='dircount'>(" .. ntotal .. " found)</div>\n")

Web.write([==[
<script>

String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

var user = "]==] .. u .. [==[";

  //if($('#dirname').text().endsWith("/pub/web"))
  var matches = /\/pub\/web(.*)$/.exec($('#dirname').text());
  if(matches)
  {
    var qwebfiles = $('.fsfile a');
    qwebfiles.each(function() {
      var q = $(this);
      var t = q.text();
      q.attr('target', t);
      q.attr('href', escape(
          '/u/' + user + (matches[1] ? matches[1] : "") + '/' + t
          )
        );
    });
  }
</script>
</body></html>
]==])


