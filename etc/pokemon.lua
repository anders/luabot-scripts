API "1.1"

if Editor then return end

local json = require "json"

local languages = {
  spanish = 7,
  english = 9
}

local LANG = languages.english

local BASE_URL = "http://pokedexd.sjofn.rfw.name/"

local replacements = {
  LANG = LANG,
}

local function query(sql, ...)
  -- look up $KEY$ in the table "replacements"
  sql = sql:gsub("%$(%w+)%$", function(key)
    return tostring(replacements[key])
  end)
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
    SELECT an.name, REPLACE(aft.flavor_text, X'0A', ' ')
    FROM ability_names an
    INNER JOIN ability_flavor_text aft ON an.ability_id = aft.ability_id
    WHERE an.local_language_id = $LANG$ AND
          aft.language_id = $LANG$ AND
          an.name like ?
    GROUP BY an.ability_id
    ORDER BY an.name ASC
  ]], name.."%")

  if #res.result.rows < 1 then
    print("no results")
    return
  end

  local name, text = unpack(res.result.rows[1])
  print(("\02%s:\02 %s"):format(name, text))
end

local function pokemon_by_name(name, exact)
  if not exact then name = name.."%" end
  local res = query([[
    SELECT p.species_id, psn.name, GROUP_CONCAT(pt.slot||':'||tn.name), GROUP_CONCAT(pa.slot||':'||an.name), REPLACE(psft.flavor_text, X'0A', ' ')
    FROM pokemon p
    INNER JOIN pokemon_species_names psn ON p.species_id = psn.pokemon_species_id
    INNER JOIN pokemon_types pt ON p.id = pt.pokemon_id
    INNER JOIN type_names tn ON pt.type_id = tn.type_id
    INNER JOIN pokemon_abilities pa ON p.id = pa.pokemon_id
    INNER JOIN ability_names an ON pa.ability_id = an.ability_id
    INNER JOIN pokemon_species_flavor_text psft ON p.id = psft.species_id
    WHERE tn.local_language_id = $LANG$ AND
          psn.local_language_id = $LANG$ AND
          an.local_language_id = $LANG$ AND
          psft.language_id = $LANG$ AND
          (psn.name LIKE ? OR p.species_id = ?)
    GROUP BY p.id
    ORDER BY psn.name ASC
    LIMIT 1
  ]], name, (name:gsub("%%", "")))

  if #res.result.rows < 1 then
    return false, "No match"
  end

  local species_id, name, types, abilities, text = unpack(res.result.rows[1])
  
  return {
    id = species_id,
    name = name,
    types = sort_types(types), -- should be "split_types" or so
    abilities = sort_types(abilities),
    text = text
  }
end

local function info(name)
  local t = assert(pokemon_by_name(name))
  
  local types = table.concat(t.types, "/")
  local abilities = table.concat({t.abilities[1], t.abilities[2]}, ", ")

  if t.abilities[3] then
    abilities = abilities..", ["..t.abilities[3].."]"
  end

  print(("\02#%03d %s:\02 %s (%s; Abilities: %s)"):format(t.id, t.name, t.text, types, abilities))
end

local function move(name)
  -- Extreme Speed: The user charges the target at blinding speed. This move always goes first. (Normal, atk. 80, acc. 100%, prio. 2)
  local res = query([[
    SELECT m.id, mn.name, m.pp, m.power, m.accuracy, tn.name, m.damage_class_id, m.priority, replace(mft.flavor_text, X'0A', ' ')
    FROM moves m
    INNER JOIN move_names mn ON m.id = mn.move_id
    INNER JOIN type_names tn ON tn.type_id = m.type_id
    INNER JOIN move_flavor_text mft ON mft.move_id = m.id
    WHERE tn.local_language_id = $LANG$ AND
          mn.local_language_id = $LANG$ AND
          mft.language_id = $LANG$ AND
          mn.name LIKE ?
    GROUP BY m.id
    ORDER BY mn.name ASC
    LIMIT 1
  ]], name.."%")
  
  if #res.result.rows < 1 then
    print("No match.")
    return
  end
  
  -- name, power, accuracy, priority, type, crit rate
  
  local id, name, pp, power, accuracy, type, dmg_class_id, priority, text =
    unpack(res.result.rows[1], 1, #res.result.cols)

  local t = {}
  t[#t+1] = type

  local classes = {"Status", "Physical", "Special"}
  if dmg_class_id and dmg_class_id > 0 then
    t[#t+1] = classes[dmg_class_id] or "???"
  end

  if power then t[#t+1] = "pow. " .. power end
  if accuracy then t[#t+1] = "acc. " .. accuracy .. "%" end
    
  if priority then
    local sign = priority > 0 and "+" or ""
    t[#t+1] = "prio. "..sign..priority
  end

  print(("\02%s:\02 %s (%s PP, %s)"):format(name, text, pp, table.concat(t, ", ")))
end

local function damage(s)
  local damage_type, target_type, target_type_2 = s:match("(%w+)%s+(%w+)/?(.*)")
  if not damage_type or not target_type then
    print("Usage: 'pokemon damage atk-type target-type[/target-type]")
    return
  end

  local res = query([[
    SELECT damage_factor, tn_damage.name, tn_target.name from type_efficacy te
    INNER JOIN type_names tn_target ON te.target_type_id = tn_target.type_id
    INNER JOIN type_names tn_damage ON te.damage_type_id = tn_damage.type_id
    WHERE tn_target.local_language_id = $LANG$ and tn_damage.local_language_id = $LANG$ and
          tn_damage.name LIKE ? AND
          (tn_target.name LIKE ? or tn_target.name LIKE ?)
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

local function defense(s)
  local res = query([[
    SELECT name FROM type_names
    WHERE name LIKE ? AND local_language_id = $LANG$
    LIMIT 1
  ]], s)

  -- only look up by pokemon name if argument is not already a type
  if #res.result.rows == 0 then
    local poke = pokemon_by_name(s)
    if poke then
      s = table.concat(poke.types, "/")
    end
  end

  local target_type, target_type_2 = s:match("(%w+)/?(.*)")
  if not target_type then
    print("Usage: 'pokemon defense target-type[/target-type] OR 'pokemon defense pokemon-name")
    return
  end

  local res = query([[
    SELECT group_concat(damage_factor, ','), tn_damage.name, group_concat(tn_target.name, '/')
    FROM type_efficacy te
    INNER JOIN type_names tn_target ON te.target_type_id = tn_target.type_id
    INNER JOIN type_names tn_damage ON te.damage_type_id = tn_damage.type_id
    WHERE tn_target.local_language_id = $LANG$ and tn_damage.local_language_id = $LANG$ and
          (tn_target.name LIKE ? or tn_target.name LIKE ?)
    GROUP BY te.damage_type_id
  ]], target_type, target_type_2 or target_type)

  if #res.result.rows < 1 then
    print("No results (wrong types or POKé Name?)")
    return
  end

  local damages = {}
  local target_name

  for i, row in ipairs(res.result.rows) do
    local factors, damage_name, t = unpack(row)
    target_name = t
    
    local factor = 1.0
    for subfactor in factors:gmatch('[^,]+') do
      factor = subfactor / 100 * factor
    end
    factor = factor * 100
    
    damages[factor] = damages[factor] or {}
    damages[factor][#damages[factor] + 1] = damage_name
  end

  local keys = {}
  for k, v in pairs(damages) do
    keys[#keys + 1] = k
  end
  table.sort(keys, function(a, b) return a > b end)

  local damage_names = {}
  for _, factor in ipairs(keys) do
    local names = damages[factor]
    table.sort(names)
    damage_names[#damage_names + 1] = ("%gx: %s"):format(factor / 100, table.concat(names, "/"))
  end

  print(("\02Type effectiveness against %s:\02 %s"):format(target_name or "N/A???", table.concat(damage_names, ", ")))
end

local function item(name)
  local res = query([[
    SELECT in_.name, i.cost, REPLACE(ift.flavor_text, X'0A', ' ')
    FROM item_names in_
    INNER JOIN items i ON in_.item_id = i.id
    INNER JOIN item_flavor_text ift ON in_.item_id = ift.item_id
    WHERE in_.local_language_id = $LANG$ AND
          ift.language_id = $LANG$ AND
          in_.name LIKE ?
    GROUP BY in_.item_id
    ORDER BY in_.name ASC
  ]], name.."%")

  if #res.result.rows < 1 then
    print("No results")
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
elseif t[1] == "defense" or t[1] == "def" then
  defense(rest)
elseif t[1] == "item" then
  item(rest)
else
  --print("unknown subcommand, assuming you meant 'pokemon info "..t[1])
  info(table.concat(t, " "))
end
