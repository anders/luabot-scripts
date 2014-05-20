-- Usage: etc.munin_graph(t) - prints data as a munin plugin, where t is a table with fields: title, vlabel, data (table of keys and values shown in the graph, key is the name and value is its numeric value); optional: logarithmic (boolean), scale (boolean), base (1024 or 1000 [default]), lowerLimit, upperLimit, rigid, unitsExponent

local t = arg[1]
assert(type(t) == "table")
assert(type(t.data) == "table", "data expected")

local function safestr(s)
  assert(type(s) == "string", "string expected")
  return s:gsub("[\r\n\t]", " ")
end

local function getOnOff(s)
  return (s and s ~= "no" and s ~= "false") and "yes" or "no"
end

local function tolabel(s)
  s = safestr(s):gsub("[^%w]", "")
  return s
end

-- Running both code paths so you can debug easier...
local configprint
local valueprint
if (Web and Web.GET["config"]) or arg[2] == 'config' then
  configprint = print
  valueprint = function() end
else
  configprint = function() end
  valueprint = print
end

local adata = {}
for k, v in pairs(t.data) do
  adata[#adata + 1] = { k = k, v = v }
end
table.sort(adata, function(a, b)
  return b.v < a.v
end)

-- if config ...
  configprint("graph_title " .. safestr(assert(t.title, "title expected")))
  configprint("graph_vlabel " .. safestr(assert(t.vlabel, "vlabel expected")))
  if t.scale ~= nil then
    configprint("graph_scale " .. getOnOff(t.scale))
  end
  local islowerlim = ""
  if tonumber(t.lowerLimit) then
    islowerlim =  " --lower-limit " .. tonumber(t.lowerLimit)
  end
  local isupperlim = ""
  if tonumber(t.upperLimit) then
    isupperlim =  " --upper-limit " .. tonumber(t.upperLimit)
  end
  local islog = ""
  if getOnOff(t.logarithmic) == "on" then
    islog = " --logarithmic"
  end
  local isrigid = ""
  if getOnOff(t.rigid) == "on" then
    isrigid = " --rigid"
  end
  local isunitsexponent = ""
  if getOnOff(t.unitsExponent) == "on" then
    isunitsexponent = " --units-exponent"
  end
  configprint("graph_args --base " .. (tonumber(t.base) or 1000)
    .. islowerlim
    .. isupperlim
    .. islog
    .. isrigid
    .. isunitsexponent
    )
  -- for k, v in pairs(t.data) do
  for i, x in ipairs(adata) do
    local k, v = x.k, x.v
    configprint(tolabel(k) .. ".label " .. safestr(k))
  end
-- else
  -- for k, v in pairs(t.data) do
  for i, x in ipairs(adata) do
    local k, v = x.k, x.v
    valueprint(tolabel(k) .. ".value " .. assert(tonumber(v)))
  end
-- end
