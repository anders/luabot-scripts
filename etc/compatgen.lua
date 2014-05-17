print("_G = _G or {}")


local function doscope(sparent, scope, cond)
  for k, v in pairs(scope) do
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

doscope(a, b, function(k, v)
  return type(v) ~= "function"
end)
print("-- Functions:")
doscope(a, b, function(k, v)
  return type(v) == "function"
end)
