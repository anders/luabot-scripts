local argornick = (arg[1] or nick):match("[^ ]+")

local errmsg = (getLastError(argornick) or ""):match("^[^\r\n]+")
if errmsg and errmsg:len() > 0 then
  errmsg = " - " .. errmsg
end

print(boturl .. "u/byte%5B%5D/error.lua?" .. urlEncode(argornick) .. errmsg)
