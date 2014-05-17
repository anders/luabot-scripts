-- Format and print strings.
-- plugin.buttprint().print(...)
--   Turn all arguments into strings.
-- plugin.buttprint().printw(...)
--   Turn all arguments into strings, separated by a space.
-- plugin.buttprint().printf(fmt, ...)
--   Format the string using Tango/C# style format strings.
--   Positional parameters are supported.
--   Examples:
--     format("{} {}", 1, 2) == '1 2'
--     format("{2} {1}", 3, 4) == '4 3'
--     format("{:q}", "abc") == '"abc"'
--     format("{:k}", {1,2,a=4}) == "{1, 2, a}"
-- plugin.buttprint().str(...)
--   Like print(...), but return the result string instead of printing it.
-- plugin.buttprint().strw(...)
--   Like printw(...), but return the string.
-- plugin.buttprint().format(...)
--   Like printf(...), but return the string.

local M = {}

local format_value

local function is_integer(i)
    return type(i) == "number" and math.floor(i) == i and i-1 ~= i
end

local function table2string(t, maxdepth, done)
    if t == nil then
        return "nil"
    end
    assert(type(t) == "table", "table2string accepts only tables")
    if done == nil then
        done = {}
    end
    if done[t] then
        return "#" .. tostring(done[t])
    end

    if maxdepth ~= nil then
        if maxdepth <= 0 then
            return "..."
        end
        maxdepth = maxdepth - 1
    end

    -- mark as done; use an ID as value (see above)
    local idx = done._new_table_index or 0
    done._new_table_index = idx + 1
    done[t] = idx

    -- only some tables define __tostring
    -- but then it's relatively important (e.g. vector types)
    --local mt = getmetatable(t)
    --if mt and mt.__tostring then
    --    return tostring(t)
    --end
    if t.__tostring and type(t.__tostring) == "function" then
        return t.__tostring(t)
    end

    -- manually convert table to string
    -- try to follow the convention of table constructors (see Lua manual)
    -- the tricky part is to produce useful results for both arrays and AAs
    -- (they can be mixed, too)
    local res = "{"
    local function item(keypart, v)
        if #res > 1 then
            res = res .. ", "
        end
        res = res .. format_value(keypart, "", done, maxdepth)
            .. format_value(v, "q", done, maxdepth)
    end
    -- array part (covers [1, index) )
    local index = 1
    while true do
        local v = t[index]
        if not v then
            break
        end
        item("", v)
        index = index + 1
    end
    -- AA part
    for k, v in pairs(t) do
        if is_integer(k) and k >= 1 and k < index then
            -- skip, must already have been formatted above
        else
            local keypart
            if type(k) == "string" then
                -- xxx should only do this if string is a valid Lua ID
                --     if not, print it quoted, like in the else case
                keypart = k .. " = "
            else
                -- ("q" means only quote strings)
                keypart = "[" .. format_value(k, "q", done, maxdepth) .. "] = "
            end
            item(keypart, v)
        end
    end
    return res .. "}"
end

format_value = function(value, fmt, done, maxdepth)
    fmt = fmt or ""
    done = done or {}

    local quote_string = false
    local table_keys = false
    if fmt == "q" then
        quote_string = true
    elseif fmt == "k" then
        table_keys = true
    elseif fmt ~= "" then
        error("unknown format specifier: '"..fmt.."'")
    end

    local ptype = type(value)
    if ptype == "table" then
        if table_keys then
            value = etc.keys(value)
        end
        return table2string(value, maxdepth, done, table_keys)
    elseif ptype == "string" then
        if quote_string then
            return string.format("%q", value)
        end
    end

    return tostring(value)
end

-- format anything (for convenience)
-- unlike string.format(), you can format anything, including tables
-- it also uses Tango/C# style {} instead of %s
-- uses the __tostring function if available, else dumps table contents
-- allowed inside {}:
--      - ':q' if param is a string, quote it (other types aren't quoted)
--      - index, e.g. '{3}' gets the third parameter
-- returns the result as string
-- trailing unused arguments are not allowed (they show up as warning)
function M.format(fmt, ...)
    assert(type(fmt) == "string", "format() expects a format string as first"
                        .. " argument")
    local res = ""
    local function out(x)
        res = res .. x
    end
    local argc = select("#", ...)
    local args = {...}
    local argused = {}
    local nidx = 0

    local function fmt_arg(fmt)
        local function split2(s, search)
            local idx = s:find(search, 1, true)
            if not idx then
                return s, ""
            else
                return s:sub(1, idx - 1), s:sub(idx + #search)
            end
        end

        -- f = param_index[:additional_format_parameters]
        local sidx, mods = split2(fmt, ":")
        local idx = nidx + 1
        if #sidx > 0 then
            local tmp = tonumber(sidx)
            if tmp == nil then
                error("malformed parameter number in format string")
            else
                idx = tmp
            end
        end
        if idx >= 1 and idx <= argc then
            argused[idx] = true
            local arg = args[idx]
            out(format_value(arg, mods))
        else
            error("arg number " .. idx .. " not present")
        end
        --
        nidx = idx
    end

    local cur = 1
    while true do
        local n = fmt:find("{", cur, true)
        if not n then
            break
        end
        out(fmt:sub(cur, n - 1))
        cur = n + 1
        -- '{{' is not interpreted as start of a format string, and outputs '{'
        if fmt:sub(n, n + 1) == "{{" then
            out("{")
            cur = cur + 1
        else
            n = fmt:find("}", cur, true)
            if not n then
                error("missing matching '}' at position " .. (cur - 1)
                    .. " in format string '" .. fmt .. "'")
            end
            fmt_arg(fmt:sub(cur, n - 1))
            cur = n + 1
        end
    end
    out(fmt:sub(cur))
    -- warn about unused arguments
    -- Note: if this gets in the way because you actually want to ignore some
    --  arguments (like for game messages), add an invisible format parameter
    --  that serves as command to ignore unused args
    for i = 1, argc do
        if not argused[i] then
            error("arg number " .. i .. " unused")
        end
    end
    return res
end

-- find out if this is a valid array
-- an array is a table with #table integer keys in range 1, ..., #table
-- expensive because it checks each element
local function is_array(table)
    if type(table) ~= "table" then
        return false
    end
    -- # returns an integer key i with table[i] ~= nil and table[i+1] == nil
    local len = #table
    local count = 0
    for k, v in pairs(table) do
        if not (is_integer(k) and k >= 1 and k <= len) then
            return false
        end
        count = count + 1
    end
    return count == len
end

local function iif(cond, a, b)
    if cond then
        return a
    else
        return b
    end
end

-- Pretty print a table. This is meant for debugging.
local function pretty_print(val)
    local table_depth = {} -- depth of the table in the table tree
    local ref = {} -- if a table is ref'ed, the ref id string
    local new_ref = 0
    -- extra ref table to ref id string
    -- "extra" means it might not be printed in the normal table tree
    local extra_refs = {}

    local function checkdepth(t, depth)
        if type(t) ~= "table" then
            return
        end
        if table_depth[t] and table_depth[t] <= depth then
            return
        end
        table_depth[t] = depth
        for k, v in pairs(t) do
            checkdepth(v, depth + 1)
        end
    end

    checkdepth(val, 0)

    local function make_ref(t)
        if not ref[t] then
            new_ref = new_ref + 1
            ref[t] = "#" .. new_ref
        end
        return ref[t]
    end

    local done = {} -- tables printed

    local function table_cmp(a, b)
        local ka, kb = a[3], b[3]
        local tka, tkb = type(a), type(b)
        if tka == tkb then
            return ka < kb
        else
            return tka < tkb
        end
    end

    local function dotable(t, depth)
        if type(t) ~= "table" then
            return format_value(t, "q")
        end
        if table_depth[t] == depth and not done[t] then
            local res = {_isflat = true}
            done[t] = res
            for k, v in pairs(t) do
                local s_v = dotable(v, depth + 1)
                local s_k
                if type(k) == "table" then
                    local ref_k = make_ref(k)
                    extra_refs[k] = ref_k
                    s_k = ref_k
                else
                    s_k = format_value(k)
                end
                res[#res + 1] = {s_k, s_v, k}
                if type(s_v) ~= "string" then
                    res._isflat = false
                end
            end
            res._is_array = is_array(t)
            res._hasmeta = not not getmetatable(t)
            table.sort(res, table_cmp)
            return res
        else
            return make_ref(t)
        end
    end

    local tree = dotable(val, 0)

    for k, v in pairs(extra_refs) do
        dotable(v, 0)
    end

    for t, refid in pairs(ref) do
        if done[t] then
            done[t]._invref = refid
        end
    end

    local buf = ""
    local indentation = 0

    local function out(s)
        local n = s:find("\n", 1, true)
        if not n then
            buf = buf .. s
        else
            buf = buf .. s:sub(1, n - 1)
            print(string.rep(" ", indentation * 2) .. buf)
            buf = ""
            return out(s:sub(n + 1)) -- tail call
        end
    end

    local function indent(l)
        indentation = indentation + l
    end

    local function render(t)
        if type(t) ~= "table" then
            out(t)
            return
        end
        local open, close = unpack(iif(t._is_array, {"[", "]"}, {"{", "}"}))
        local flat = t._isflat
        if t._invref then
            out("<" .. t._invref .. "> ")
        end
        out(open)
        if not flat then
            out("\n")
        end
        indent(1)
        for i, v in ipairs(t) do
            if not t._is_array then
                out(v[1])
                out(" = ")
            end
            render(v[2])
            if flat then
                out(", ")
            else
                out("\n")
            end
        end
        indent(-1)
        out(close)
    end

    render(tree)

    if not next(extra_refs) ~= nil then
        out("\nExtra:\n")
        M.printw(extra_refs)
        for k, v in pairs(extra_refs) do
            render(v)
        end
    end
end

local function str_(whitespace_count, ...)
    local argc = select("#", ...)
    local res = ""
    for i = 1, argc do
        local val = select(i, ...)
        res = res .. format_value(val)
        if whitespace_count > 0 and i ~= argc then
            res = res .. string.rep(" ", whitespace_count)
        end
    end
    return res
end

function M.str(...)
    return str_(0, ...)
end

function M.strw(...)
    return str_(1, ...)
end

function M.print(...)
    print(M.str(...))
end

function M.printw(...)
    print(M.strw(...))
end

function M.printf(...)
    print(M.format(...))
end

M.pretty_print = pretty_print

return M
