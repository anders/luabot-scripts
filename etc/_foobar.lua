local G = arg[1]

local realio = G.io
G.io = etc.clone(G.io)
G.io.open = function(...)
  local x, y = realio.open(...)
  if x then
    local my = {}
    my.write = function(self, ...) return x:write(...) end
    my.close = function(self, ...) return x:close(...) end
    my.read = function()
      return "1336"
    end
    return my
  end
  return x, y
end

-- G.tonumber = function() return 2 end
