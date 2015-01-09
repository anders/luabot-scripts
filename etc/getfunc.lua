local name = arg[1]
  local mod = etc
  local x, y = name:match("^([^%.]+)%.(.+)$")
  if x and y then
    if not _G[x] then
      return nil, "fail 1"
    end
    mod = _G[x]
  end
  local f = mod[name]
  if f then
    return f
  end
  if mod.findFunc then
    local lowername = name:lower()
    local all = mod.findFunc()
    for i = 1, #all do
      if lowername == all[i]:lower() then
        f = mod[all[i]]
        assert(f, "Found function but could not get it")
        return f
      end
    end
  end
  return nil, "fail 2"
