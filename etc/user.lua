if arg[1] == '\'' then
  return "no u"
end

local whom, optPage = (arg[1] or nick):match("([^ ]+) ?([^ ]*)")
if tonumber(whom) or whom:sub(1, 1) == '+' then
  local whomname = getname(tonumber(whom) or -999)
  if whom:sub(1, 1) == '+' or not whomname then
    -- error("Did you mean to use 'U " .. arg[1])
    -- error("Did you mean to use 'U")
    print("Passing to 'U")
    print(etc.U(arg[1]))
    return
  end
  whom = whomname
end
if optPage and optPage:len() > 0 then
  return boturl .. "u/" .. urlEncode(whom) .. "/" .. optPage
end
return "User page for " .. whom .. ": " .. boturl .. "u/" .. urlEncode(whom)
