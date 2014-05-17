if Editor then
  arg[1] = "hello 14:01 ... 21:22:20 done"
end

local result
if arg[1] then
  if arg[1]:find("[AP]M") or arg[1]:find("%d *[aApP]") then
    result = arg[1]
  else
    result = arg[1]:gsub("([0-2]?[0-9]):([0-9][0-9]):?([0-9]?[0-9]?)", function(a, b, c)
      local an = tonumber(a)
      -- local bn = tonumber(b)
      local cn = tonumber(c)
      local newhour = an
      local ampm = "AM"
      if an == 0 then
        newhour = 12
      elseif an >= 12 then
        ampm = "PM"
        if an >= 13 then
          newhour = an - 12
        end
      end
      
      local r = ""
      
      local orig = a .. ':' .. b
      if cn then
        orig = orig .. ':' .. c
      end
      
      local conv = newhour .. ':' .. b
      if cn then
        conv = conv .. ':' .. c
      end
      conv = conv .. ' ' .. ampm
      
      -- return orig .. " (" .. conv .. ")"
      return conv
      
    end)
  end
end

if result then
  if Editor then
    print(result)
  end
  return result
end
