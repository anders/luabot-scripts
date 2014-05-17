local c = "_.,=-*'~`"
local f, xstep, ymin, ymax, xstart, xend = arg[1] or math.sin, arg[2] or 0.3, arg[3] or -1, arg[4] or 1, arg[5] or 0, arg[6] or 5 * math.pi
local s = ""
for x = xstart, xend, xstep do
    h = (f(x)-ymin)/(ymax-ymin)*c:len();
    if h < c:len() then
        s = s .. c:sub(h + 1, h + 1)
    else
        s = s .. ' '
    end
end
return s