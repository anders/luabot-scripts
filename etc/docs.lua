if not Web then
  if not arg[1] then
    return boturl .. "u/" .. urlEncode(getname(owner())) .. "/docs.lua"
  end
  return etc.web_docgen(arg[1])
end

-- local storage = require 'storage'
-- local markdown = require 'markdown'

-- local docstore = storage.load(io, "dbot.docs")

local scope = Web.GET['scope'] or "_G"

local allscopes = { }
for k, v in pairs(_G) do
  if type(v) == 'table' then
    local i = 0
    local nfuncs = 0
    -- Make sure there's lots o' functions,
    for kx, vx in pairs(v) do
      if i > 10 then
        break
      end
      if type(vx) == 'function' then
        nfuncs = nfuncs + 1
      end
    end
    if nfuncs > i / 2 then
      allscopes[#allscopes + 1] = k
    end
  end
end
table.sort(allscopes)

local keys = {}
if scope == "_G" then
  for k, v in pairs(_G) do
    -- if type(v) == 'function' then
    keys[#keys + 1] = { '_G.'..k, _getHelp }
    -- end
  end
else
  assert(_G[scope], "Unknown scope")
  if _G[scope].findFunc and _G[scope].cmdprefix then
    for ix, name in ipairs(_G[scope].findFunc()) do
      keys[#keys + 1] = { scope .. '.'..name, function() return "user..." end }
    end
  else
    for k, v in pairs(_G[scope]) do
      keys[#keys + 1] = { scope .. '.'..k, function() return type(v) .. "..." end }
    end
  end
end
table.sort(keys, function(a, b)
  local r = a[1] < b[1]
end)

Web.write([[
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>docs for ]] .. scope .. [[</title>
<style>
  body { font: arial, sans serif; color: black; background-color: white; }
  a { color: black; }
  .goscope { display: inline-block; margin-left: 0.25em; margin-right: 0.25em; }
  .nohelp { color: gray; font-style: italic; }
</style>
</head>
<body>]])
for i = 1, #allscopes do
  local xtra = ""
  if allscopes[i] == scope then
    xtra = " *"
  end
  Web.write([[<div class="goscope"><a href="]]
    .. (Web.scriptName or 'docs.lua') .. '?scope=' .. allscopes[i]
    .. [[">]] .. allscopes[i] .. [[</a>]] .. xtra .. [[</div>]])
end
Web.write([[
  <h3>]] .. scope .. [[</h3>
  <table class="table" width="100%" border="1">
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
]])

for k, info in ipairs(keys) do
  local v = info[1]
  local vhelp = info[2]
  -- local desc = markdown(docstore[v] or '')
  
  if v:find('^_G%.') then v = v:sub(4) end
  
  local desc
  if etc.islua(v) == 1 then
    desc = "<a target='lua' href='http://www.lua.org/manual/5.1/manual.html#pdf-" .. v .. "'>" .. v .. " is part of the Lua API</a>"
  else
    desc = vhelp(v) or "<span class='nohelp'>Help not available</span>"
    -- desc = etc.getReturn(etc.help(v)) or "<span class='nohelp'>Help not available</span>"
  end
  
  Web.write('<tr>')
  Web.write('  <td class="key">'..v..'</td>')
  Web.write('  <td class="desc">'..desc..'</td>')
  Web.write('</tr>')
end

Web.write[[
  </table>
</body>
</html>
]]
