API "1.1"

local function ok(x)
  local u = ""
  for k in x:gmatch("[a-zA-Z0-9]+") do
    u = u .. k
  end
  return u:lower()
end

return etc.nonickalert(  ok(etc.funword()) .. "_" .. ok(rnick())  )
