-- These might be incorrect!
-- Have fun fixing them.

local M = {}

function M.normalize(n)
    return n:lower()
end

function M.compare(n1, n2)
    return M.normalize(n1) == M.normalize(n2)
end

return M
