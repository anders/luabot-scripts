local reduce = function(fun, list, def)
    for k, v in ipairs(list) do def = fun(def, v) end
    return def
end

local rand = math.random
local tconc = table.concat

local benisify = function(s)
    return reduce(function(acc, f) return f(acc) end, {
        function(s) return s:lower() end,
        function(s) return s:gsub('x', 'cks') end,
        function(s) return s:gsub('ing', 'in') end,
        function(s) return s:gsub('you', 'u') end,
        function(s) return s:gsub('oo', function()
            return ('u'):rep(rand(1, 5))
        end) end,
        function(s) return s:gsub('[%w_]%z', function(x)
            return x:sub(1, 1):rep(rand(1, 2))
        end) end,
        function(s) return s:gsub('ck', function()
            return ('g'):rep(rand(1, 5))
        end) end,
        function(s) return s:gsub('(t+)%f[aeiouys ]', function(x)
            return ('d'):rep(#x)
        end) end,
        function(s) return s:gsub('(t+)$', function(x)
            return ('d'):rep(#x)
        end) end,
        function(s) return s:gsub('p', 'b') end,
        function(s) return s:gsub('%f[%w_]the%f[^%w_]', 'da') end,
        function(s) return s:gsub('%f[%w_]c', 'g') end,
        function(s) return s:gsub('%f[%w_]is%f[^%w_]', 'are') end,
        function(s) return s:gsub('(c+)(.)', function(x, y)
            return (y == 'e' or y == 'i' or y == 'y')
                and (x .. y) or (('g'):rep(rand(1, 5)) ..
                    (y == 'c' and 'g' or y))
        end) end,
        function(s) return s:gsub('([qk]+)%f[aeiouy ]', function()
            return ('g'):rep(rand(1, 5))
        end) end,
        function(s) return s:gsub('([qk]+)$', function()
            return ('g'):rep(rand(1, 5))
        end) end,
        function(s)
            local endswith = s:find('[?!.]$')
            local repf = function(x)
                local ret = x:rep(rand(2, 5)) .. ' '
                for i = 1, rand(2, 5) do
                    ret = ret .. (':'):rep(rand(1, 2)) .. ('D'):rep(rand(1, 4))
                end
                return ret
            end
            s = s:gsub('[?!.]+', repf)
            if not endswith then return s:gsub('$', repf) end
            return s
        end
    }, s)
end

return ('%q'):format(tconc(arg, " "))
--return benisify(tconc(arg, " "))