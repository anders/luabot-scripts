if not Web then return end

local storage = require 'storage'
local markdown = require 'markdown'

local docstore = storage.load(io, "dbot.docs")

local keys = {}
for k, v in pairs(_G) do
  if type(v) == 'function' then
    keys[#keys + 1] = '_G.'..k
  end
end
table.sort(keys)

Web.write[[
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Help – Kobun
</title>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css">
<style type="text/css">
html,
body {
  height: 100%;
}

#wrap {
  min-height: 100%;
  height: auto;
  margin: 0 auto -60px;
  padding: 0 0 60px;
}

#footer {
  height: 60px;
  background-color: #f5f5f5;
}

#wrap > .container {
  padding: 60px 15px 0;
}

.container .text-muted {
  margin: 20px 0;
}

#footer > .container {
  padding-left: 15px;
  padding-right: 15px;
}

.quotes-container {
  padding-top: 50px;
}

.service-list {
  column-gap: 30px;
  -webkit-column-gap: 30px;
  -moz-column-gap: 30px;
}

.service-list li {
  page-break-inside: avoid;
  -webkit-column-break-inside: avoid;
  -moz-column-break-inside: avoid;
  column-break-inside: avoid;
}

.config-options p, .config-options dl {
  margin-bottom: 0;
}

.config-options p {
  display: inline;
}

.navbar-secondary {
  top: 51px;
}

@media (min-width: 768px) {
  .service-list {
    columns: 2;
    -webkit-columns: 2;
    -moz-columns: 2;
  }

  dl.docutils dt {
    float: left;
    width: 160px;
    clear: left;
    text-align: right;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap
  }

  dl.docutils dd {
    margin-left: 180px
  }
}

@media (min-width: 992px) {
  .service-list {
    columns: 3;
    -webkit-columns: 3;
    -moz-columns: 3;
  }
}
</style>
</head>
<body>
<div id="wrap">
<nav class="navbar navbar-default navbar-fixed-top navbar-inverse" role="navigation">
<div class="container">
<div class="navbar-header">
<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar">
<span class="sr-only">Toggle navigation</span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</button>
<a class="navbar-brand" href="/">Kobun</a>
</div>
<div class="collapse navbar-collapse" id="navbar">
<ul class="nav navbar-nav">


<li>
<a href="/quotes/">Quotes</a>
</li>





<li class="active">
<a href="/help/">Help</a>
</li>


</ul>
</div>
</div>
</nav>


<div class="container">

<h1>Help</h1>
Welcome to the online documentation for services and configuration options.
  <table class="table" width="100%">
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
]]

for k, v in ipairs(keys) do
  local desc = markdown(docstore[v] or '')
  
  if v:find('^_G%.') then v = v:sub(4) end
  
  Web.write('<tr>')
  Web.write('  <td class="key">'..v..'</td>')
  Web.write('  <td class="desc">'..desc..'</td>')
  Web.write('</tr>')
end

Web.write[[
  </table>
</div>
<div id="footer">
<div class="container">
<p class="text-muted">
<a href="https://github.com/rfw/kochira">github.com/rfw/kochira</a> ·

75e635ea

</p>
</div>
</div>

<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
</body>
</html>
]]