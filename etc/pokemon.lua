API "1.1"

if Editor then return end

local json = require "json"

local LANG_ES = 7
local LANG_EN = 9

local LANG = LANG_EN

local BASE_URL = "http://pokedexd.sjofn.rfw.name/"

local function query(sql, ...)
  -- &param=.. for prepared statements
  local url = BASE_URL.."?q="..urlEncode(sql)
  for i=1, select("#", ...) do
    local param = tostring(select(i, ...))
    url = url.."&param="..urlEncode(param)
  end
  local resp = assert(httpGet(url))
  local d = assert(json.decode(resp))
  assert(d.success, d.error)
  return d
end

local t = {}
for w in arg[1]:gmatch("[^%s]+") do t[#t + 1] = w end

local function sort_types(type_list)
  local t = {}
  for kv in type_list:gmatch("[^,]+") do
    local slot, name = kv:match("(%d+):(.+)")
    t[tonumber(slot)] = name
  end
  return t
end

local function info(name)
  local res = query([[
    select p.species_id, psn.name, group_concat(pt.slot||':'||tn.name) AS types
    from pokemon p
    inner join pokemon_species_names psn on p.species_id = psn.pokemon_species_id
    inner join pokemon_types pt on p.id = pt.pokemon_id
    inner join type_names tn on pt.type_id = tn.type_id
    where tn.local_language_id = ? and
          psn.local_language_id = ? and
          psn.name like ?
    group by p.id
    order by psn.name asc
  ]], LANG, LANG, name.."%")

  if #res.result.rows < 1 then
    print("no results")
    return
  end

  local species_id, name, types = unpack(res.result.rows[1])
  types = table.concat(sort_types(types), "/")

  print(("#%03d: %s (%s)"):format(species_id, name, types))
end

local function move(name)
  -- Extreme Speed: The user charges the target at blinding speed. This move always goes first. (Normal, atk. 80, acc. 100%, prio. 2)
  local res = query([[
    select m.id, mn.name, m.power, m.accuracy, tn.name, m.damage_class_id, m.priority, replace(mft.flavor_text, X'0A', ' ')
    from moves m
    inner join move_names mn on m.id = mn.move_id
    inner join type_names tn on tn.type_id = m.type_id
    inner join move_flavor_text mft on mft.move_id = m.id
    where tn.local_language_id = ? and mn.local_language_id = ? and mft.language_id = ? and mn.name like ?
    group by m.id
    order by mn.name asc
  ]], LANG, LANG, LANG, name.."%")
  
  if #res.result.rows < 1 then
    print("no results")
    return
  end
  
  -- name, power, accuracy, priority, type, crit rate
  
  local id, name, power, accuracy, type, dmg_class_id, priority, text =
    unpack(res.result.rows[1], 1, #res.result.cols)

  local t = {}
  
  if power then t[#t+1] = "Power: "..power end
  if accuracy then t[#t+1] = "Accuracy: "..accuracy end
  
  t[#t+1] = "Type: "..type
  
  local classes = {"Status", "Physical", "Sp.Atk."}
  if dmg_class_id and dmg_class_id > 0 then
    t[#t+1] = "Class: "..(classes[dmg_class_id] or "???")
  end
  
  if priority then t[#t+1] = "Priority: "..priority end
  
  if text then t[#t+1] = text end
  
  print(name..": "..table.concat(t, "; "))
end

local rest = table.concat(t, " ", 2)
if t[1] == "move" then
  move(rest)
elseif t[1] == "ability" then
  ability(rest)
elseif t[1] == "info" then
  info(rest)
else
  --print("unknown subcommand, assuming you meant 'pokemon info "..t[1])
  info(table.concat(t, " "))
end
