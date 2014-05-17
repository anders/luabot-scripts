-- Usage: etc.callall(lua_pattern) calls all etc functions matching the lua pattern.
local lua_pattern = arg[1]
local t = {}
local dummy = (function(skip, ...)
  local all = etc.findFunc(lua_pattern)
  for i = 1, #all do
    t[#t + 1] = { pcall(etc[all[i]], ...) }
  end
end)(...)
return t