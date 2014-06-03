-- Return path to web page and exit on IRC/elsewhere.
if not Web then
  return etc.user(("%s patterns.lua"):format(getname(owner())))
end

local tmpl = require "tmpl"

-- POST options. not local as the template needs them.
options = {}
post = {}

-- handle POST
if Web.data then
  for kv in Web.data:gmatch("[^&]+") do
    local key, value = kv:match("([^=]+)=(.+)")
    if key == "options" then
      options[value] = true
    elseif key and value then
      post[key] = urlDecode(value)
    end
  end
end

post.pattern = post.pattern or [[
[&%?]([^=]+)=([^&]*)
]]

post.data = post.data or [[
asdf=baf&fjdsiafj=ajgj&lololo=123
]]

post.repl = post.repl or [[
1=%1; 2=%2
]]

if #post.pattern == 0 then post.pattern = nil end
if #post.data == 0 then post.data = nil end
if #post.repl == 0 then post.repl = nil end

if post.pattern and post.data then
  matches = {post.data:match(post.pattern)}
  if post.repl then
    replresult = post.data:gsub(post.pattern, post.repl)
  end
end

local code = tmpl.compile([====[
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
  body {
    font-family: Helvetica, Arial, sans-serif;
  }
  code, textarea {
    font-size: 14px;
    font-family: monospace;
  }
  th {
    text-align: left;
  }
  pre {
    margin: 0;
  }
  </style>
  <title>Patterns</title>
</head>
<body>
  <h1>Lua pattern helper</h1>
  <hr>
  <form enctype="application/x-www-form-urlencoded" method="post">
    <h3>Options</h3>
    
    <!--
    <input id="repl" type="checkbox" name="options" value="repl">
    <label for="repl">Use replacement pattern</label>
    <br>
    -->

    <input id="replfun" type="checkbox" name="options" value="replfun">
    <label for="replfun">Replacement is Lua code (use ... for args)</label>
    <hr>

    <label for="pattern">Pattern</label>
    <br>
    <textarea id="pattern" name="pattern" rows="4" cols="100">{{ htmlescape(post.pattern or "") }}</textarea>
    <br>

    <label for="replacement">Replacement</label>
    <br>
    <textarea id="repl" name="repl" rows="4" cols="100">{{ htmlescape(post.repl or "") }}</textarea>
    <br>

    <label for="data">Data</label><br>
    <textarea id="data" name="data" rows="20" cols="100">{{ htmlescape(post.data or "") }}</textarea>
    <br>

    {% if matches then %}
    <hr>

    <table border="1" width="600px">
      <tr>
        <th width="50px">#</th>
        <th>Match</th>
      </tr>
      {% for i, match in ipairs(matches) do %}
      <tr>
        <td>{{ i }}</td>
        <td><pre>{{ htmlescape(match) }}</pre></td>
      </tr>
      {% end %}
    </table>
    {% end %}
    
    {% if replresult then %}
    <hr>
    <b>Output</b>
    <pre>{{ htmlescape(replresult) }}</pre>
    {% end %}

    <hr>

    <input type="submit" value="Submit">
  </form>
</body>
</html>
]====])

--[[
Web.header("Content-Type: text/plain")
Web.write(code)
do return end]]
Web.write(assert(loadstring(code))())
