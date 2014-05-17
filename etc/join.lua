local s
local joinby = "\t"

if arg[1] then
  if type(arg[1]) == "function" then
    s = etc.getOutput(...)
    -- Don't set joinby here, the args were already passed to the function.
  elseif type(arg[1]) == "string" and arg[1]:sub(1, 1) == "'" then
    -- Note: might want to remove this; it can confuse the input intent:
    local tick = arg[1]:sub(2)
    assert(not tick:find("'"), "Not supported at the moment: " .. arg[1])
    if tick:find("[ %.!%-,:;]") or not etc[tick] then
      s = arg[1]
      joinby = arg[2] or joinby
    else
      s = etc.getOutput(etc[tick]);
      -- Don't set joinby for this case, for future compat with etc[tick] args.
      assert(phrase and phrase:len() > 0, "There's no output")
    end
  else
    s = arg[1]
    joinby = arg[2] or joinby
  end
else
  error("Argument expected")
end

local rr = s:gsub("\r?\n", joinby)
return(rr)
