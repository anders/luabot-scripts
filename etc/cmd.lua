-- Usage: pass in a string and it'll be treated the same way as issuing the command directly from IRC, such as etc.cmd("'say hi")
local etcname, etcargs = (arg[1] or ''):match("^'([a-zA-Z_0-9%.]+)[ ]?(.-)%s*$")
if not etcname then
  return nil, "Unable to parse command"
end
return etc.on_cmd(etcname, etcargs)
