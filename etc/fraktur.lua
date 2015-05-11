API "1.1"

local tofraktur = function(str)
    local buf = {}
    for c in str:gmatch(".") do
        local n = c:byte()
        if n >= 65 and n <= 90 then
            if n >= 85 then
                buf[#buf + 1] = string.char(0xF0, 0x9D, 0x96, 0x80 + n - 85)
            else
                buf[#buf + 1] = string.char(0xF0, 0x9D, 0x95, 0xAC + n - 65)
            end
        elseif n >= 97 and n <= 122 then
            -- lowercase
            buf[#buf + 1] = string.char(0xF0, 0x9D, 0x96, 0x86 + n - 97)
        else
            -- passthrough
            buf[#buf + 1] = c
        end
    end
    return table.concat(buf)
end

return tofraktur(table.concat(arg, " "))
