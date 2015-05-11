API "1.1"

local fmap = {
    [("C"):byte()] = string.char(0xF0, 0x9D, 0x95, 0xAE),
    [("H"):byte()] = string.char(0xF0, 0x9D, 0x95, 0xB3),
    [("I"):byte()] = string.char(0xF0, 0x9D, 0x95, 0xB4),
    [("R"):byte()] = string.char(0xF0, 0x9D, 0x95, 0xBD),
    [("Z"):byte()] = string.char(0xF0, 0x9D, 0x96, 0x85)
}

local tofraktur = function(str)
    local buf = {}
    for c in str:gmatch(".") do
        local n = c:byte()
        if n >= 65 and n <= 90 then
            if fmap[n] then
                buf[#buf + 1] = fmap[n]
            else
                buf[#buf + 1] = string.char(0xF0, 0x9D, 0x94, 0x84 + n - 65)
            end
        elseif n >= 97 and n <= 122 then
            -- lowercase
            buf[#buf + 1] = string.char(0xF0, 0x9D, 0x94, 0x9E + n - 97)
        else
            -- passthrough
            buf[#buf + 1] = c
        end
    end
    return table.concat(buf)
end

return tofraktur(table.concat(arg, " "))
