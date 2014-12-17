API "1.1"

local lpeg = require "lpeg"

local function unescape_string(s)
    -- hack
    return (s:gsub("\\n", "\n"):gsub("\\t", "\t"))
end

local V, S, P, Ct, C, R = lpeg.V, lpeg.S, lpeg.P, lpeg.Ct, lpeg.C, lpeg.R

local G = {
    V"Script",

    Space = S" \t"^0,
    EOL = P"\r\n" + P"\n",
    Separator = P";" + V"EOL",

    Script = Ct(V"Space" * V"Statement" * (V"Space" * V"Separator" * V"Statement")^0),
    Statement = Ct(V"Value"^1)^-1,
    PlainString = C((R("AZ", "az", "09") + P"_" + S"-.,:")^1),
    QuotedString = (P"\"" * C(((1 - S"\"\r\n\t\\") + (P"\\" * 1))^0) * "\"") / unescape_string,
    String = V"Space" * (V"PlainString" + V"QuotedString"),
    CommandSubst = V"Space" * "[" * Ct(V"Value"^0) * V"Space" * "]",
    Value = V"String" + V"CommandSubst"
}

local function exec(stat)
    local ident = stat[1]
    if type(ident) == "table" then
        ident = exec(ident)
    end

    local args = {}

    for i=2, #stat do
        args[i-1] = type(stat[i]) == "table" and exec(stat[i]) or stat[i]
    end

    return etc.getOutput(etc[ident], table.concat(args, " "))
end

local input = table.concat(arg, " ")

for _, statement in ipairs(lpeg.match(G, input)) do
    print(exec(statement))
end
