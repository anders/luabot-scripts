if not Web then
  return etc.user('anders patterns.lua')
end

if Web.data and #Web.data > 0 then
  Web.header("Content-Type: text/plain")
  Web.write(Web.data)
  return
end

Web.write([====[
<!DOCTYPE html>
<!-- Very 90's HTML, sorry -->
<html>
<head>
  <meta charset="utf-8"> <!-- Like every good citizen. -->
  <style>
  body {
    font-family: Arial, Helvetica, sans-serif;
  }
  code, textarea {
    font-size: 14px;
    font-family: monospace;
  }
  th {
    text-align: left;
  }
  </style>
  <title>Patterns</title>
</head>
<body>
  <h1>Lua pattern helper</h1>
  <hr>
  <form enctype="application/x-www-form-urlencoded" method="post">
    <h3>Options</h3>
    <input id="repl" type="checkbox" name="options" value="repl">
    <label for="repl">Use replacement pattern</label>
    <br>

    <input id="replfun" type="checkbox" name="options" value="replfun">
    <label for="replfun">Replacement is Lua code</label>
    <hr>

    <label for="pattern">Pattern</label>
    <br>
    <textarea id="pattern" name="pattern" rows="4" cols="100"></textarea>
    <br>

    <label for="replacement">Replacement</label>
    <br>
    <textarea id="repl" name="repl" rows="4" cols="100"></textarea>
    <br>

    <label for="data">Data</label><br>
    <textarea id="data" name="data" rows="20" cols="100"></textarea>
    <br>

    <table border="1" width="600px">
      <tr>
        <th width="50px">#</th>
        <th>Match</th>
      </tr>
      <tr>
        <td>1</td>
        <td><code>asdfasdf</code></td>
      </tr>
    </table>
    <hr>

    <input type="submit" value="Submit">
  </form>
</body>
</html>
]====])