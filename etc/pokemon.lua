API "1.1"

if Editor then return end

local json = require "json"

local LANG_ES = 7
local LANG_EN = 9

local LANG = LANG_EN

local BASE_URL = "http://pokedexd.sjofn.rfw.name/"

local function query(sql, ...)
  sql = sql:gsub("%$LANG%$", LANG)
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

local function ability(name)
  local res = query([[
    select an.name, replace(aft.flavor_text, X'0A', ' ')
    from ability_names an
    inner join ability_flavor_text aft on an.ability_id = aft.ability_id
    where an.local_language_id = $LANG$ and
          aft.language_id = $LANG$ and
          an.name like ?
    group by an.ability_id
    order by an.name asc
  ]], name.."%")

  if #res.result.rows < 1 then
    print("no results")
    return
  end

  local name, text = unpack(res.result.rows[1])
  print(("\02%s:\02 %s"):format(name, text))
end

local function info(name)
  local res = query([[
    select p.species_id, psn.name, group_concat(pt.slot||':'||tn.name), group_concat(pa.slot||':'||an.name), replace(psft.flavor_text, X'0A', ' ')
    from pokemon p
    inner join pokemon_species_names psn on p.species_id = psn.pokemon_species_id
    inner join pokemon_types pt on p.id = pt.pokemon_id
    inner join type_names tn on pt.type_id = tn.type_id
    inner join pokemon_abilities pa on p.id = pa.pokemon_id
    inner join ability_names an on pa.ability_id = an.ability_id
    inner join pokemon_species_flavor_text psft on p.id = psft.species_id
    where tn.local_language_id = $LANG$ and
          psn.local_language_id = $LANG$ and
          an.local_language_id = $LANG$ and
          psft.language_id = $LANG$ and
          (psn.name like ? or p.species_id = ?)
    group by p.id
    order by psn.name asc
  ]], name.."%", name)

  if #res.result.rows < 1 then
    print("no results")
    return
  end

  local species_id, name, types, abilities, text = unpack(res.result.rows[1])
  types = table.concat(sort_types(types), "/")
  sorted_abilities = sort_types(abilities)

  abilities = table.concat({sorted_abilities[1], sorted_abilities[2]}, ", ")
  
  if sorted_abilities[3] then
   abilities = abilities .. ", [" .. sorted_abilities[3] .. "]"
  end

  print(("\02#%03d %s:\02 %s (%s; Abilities: %s)"):format(species_id, name, text, types, abilities))
end

local function move(name)
  -- Extreme Speed: The user charges the target at blinding speed. This move always goes first. (Normal, atk. 80, acc. 100%, prio. 2)
  local res = query([[
    select m.id, mn.name, m.power, m.accuracy, tn.name, m.damage_class_id, m.priority, replace(mft.flavor_text, X'0A', ' ')
    from moves m
    inner join move_names mn on m.id = mn.move_id
    inner join type_names tn on tn.type_id = m.type_id
    inner join move_flavor_text mft on mft.move_id = m.id
    where tn.local_language_id = $LANG$ and
          mn.local_language_id = $LANG$ and
          mft.language_id = $LANG$ and
          mn.name like ?
    group by m.id
    order by mn.name asc
  ]], name.."%")
  
  if #res.result.rows < 1 then
    print("no results")
    return
  end
  
  -- name, power, accuracy, priority, type, crit rate
  
  local id, name, power, accuracy, type, dmg_class_id, priority, text =
    unpack(res.result.rows[1], 1, #res.result.cols)

  local t = {}
  t[#t+1] = type

  local classes = {"Status", "Physical", "Special"}
  if dmg_class_id and dmg_class_id > 0 then
    t[#t+1] = classes[dmg_class_id] or "???"
  end

  if power then t[#t+1] = "pow. " .. power end
  if accuracy then t[#t+1] = "acc. " .. accuracy .. "%" end
    
  if priority then t[#t+1] = "prio. "..priority end
  
  print(("\02%s:\02 %s (%s)"):format(name, text, table.concat(t, ", ")))
end

local function damage(s)
  local damage_type, target_type, target_type_2 = s:match("(%w+)%s+(%w+)/?(.*)")
  if not damage_type or not target_type then
    print("Usage: 'pokemon damage atk-type target-type[/target-type]")
    return
  end

  local res = query([[
    select damage_factor, tn_damage.name, tn_target.name from type_efficacy te
    inner join type_names tn_target on te.target_type_id = tn_target.type_id
    inner join type_names tn_damage on te.damage_type_id = tn_damage.type_id
    where tn_target.local_language_id = $LANG$ and tn_damage.local_language_id = $LANG$ and
          tn_damage.name like ? and
          (tn_target.name like ? or tn_target.name like ?)
  ]], damage_type, target_type, target_type_2)

  local factor = 1.0
  local damage
  local target = {}

  for i, row in ipairs(res.result.rows) do
    local subfactor, damage_name, target_name = unpack(row)
    damage = damage_name
    target[#target + 1] = target_name
    factor = factor * (subfactor / 100)
  end

  print(("\02%s vs. %s:\02 %.0f%%"):format(damage, table.concat(target, "/"), factor * 100))
end

local function item(name)
  local res = query([[
    select in_.name, i.cost, replace(ift.flavor_text, X'0A', ' ')
    from item_names in_
    inner join items i on in_.item_id = i.id
    inner join item_flavor_text ift on in_.item_id = ift.item_id
    where in_.local_language_id = $LANG$ and
          ift.language_id = $LANG$ and
          in_.name like ?
    group by in_.item_id
    order by in_.name asc
  ]], name.."%")

  if #res.result.rows < 1 then
    print("no results")
    return
  end

  local name, cost, text = unpack(res.result.rows[1])
  print(("\02%s:\02 %s%s"):format(name, text, cost > 0 and " (₱"..cost..")" or ""))
end

local rest = table.concat(t, " ", 2)
if t[1] == "move" then
  move(rest)
elseif t[1] == "ability" then
  ability(rest)
elseif t[1] == "info" or t[1] == "mon" then
  info(rest)
elseif t[1] == "damage" or t[1] == "dmg" then
  damage(rest)
elseif t[1] == "item" then
  item(rest)
else
  --print("unknown subcommand, assuming you meant 'pokemon info "..t[1])
  info(table.concat(t, " "))
end
