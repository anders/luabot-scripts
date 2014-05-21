print("_G = _G or {}")


local function doscope(sparent, scope, cond)
  local keys = {}
  for k, v in pairs(scope) do keys[#keys + 1] = k end
  table.sort(keys)

  for _, k in ipairs(keys) do
    local v = scope[k]
    if not cond or cond(k, v) then
      local xk
      if type(k) == "number" then
        xk = k
      elseif type(k) == "string" then
        xk = string.format("%q", k)
      end
      if xk and k ~= "_G" then
        local xv
        if type(v) == "number" then
          xv = v
        elseif type(v) == "string" then
          xv = string.format("%q", v)
        elseif type(v) == "table" then
          xv = "{}"
        elseif type(v) == "function" then
          xv = "function() return nil, 'Not implemented'; end"
        end
        if xv then
          local first = sparent .. "[" .. xk .. "]"
          if sparent ~= "_G" or not etc.islua(k) then
            print(first .. "=" .. xv)
            if type(v) == "table" then
              doscope("  " .. first, v, cond)
            end
          end
        end
      end
    end
  end
end

local a = "_G"
local b = guestloadstring("return _G")()

if not (arg[1] or ''):find("-novars", 1, true) then
  doscope(a, b, function(k, v)
    return type(v) ~= "function"
  end)
end
if not (arg[1] or ''):find("-nofuncs", 1, true) then
  print("-- Functions:")
  doscope(a, b, function(k, v)
    return type(v) == "function"
  end)
end
