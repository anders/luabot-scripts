arg, io.stdin = etc.stdio(arg)
local text
local data = io.stdin:read('*a')

if #data > 0 then
    text = data
else
    local tmp = {}
    for i=3, #arg do
        tmp[i - 2] = arg[i]
    end
    text = table.concat(tmp, ' ')
end

Input.piped = false
return etc.getOutput(etc.translate, 'xx en '..text)