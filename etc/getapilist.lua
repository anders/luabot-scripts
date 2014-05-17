local function apilist(t, prefix, output)
    if prefix == "_G."
        or prefix == "package.preload."
        or prefix == "package.loaded."
        then
      return
    end
    t._foundapi = true
    -- print("scanning", prefix)
    for k, v in pairs(t) do
        if type(k) == "string" and k ~= "_foundapi" then
            -- print("", "found", prefix, k, "output index=", #output+1)
            output[#output + 1] = prefix .. k
            if type(v) == "table" and not v._foundapi then
                apilist(v, prefix .. k .. ".", output)
            end
        end
    end
    return output
end

return apilist(arg[1] or _G, "", arg[2] or {})
