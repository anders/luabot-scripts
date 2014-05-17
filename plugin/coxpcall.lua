
-- Fake coxpcall.

assert(pcall, "pcall required for coxpcall")

if not xpcall then
  xpcall = function(f, err)
    return pcall(f)
  end
end

return { pcall = pcall, xpcall = xpcall }
