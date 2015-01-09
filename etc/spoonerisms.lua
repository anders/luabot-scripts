API "1.1"

return arg[1]:gsub("%f[%a]([^aeiouyAEIOUY%A]+)(%a*)(%s+)([^aeiouyAEIOUY%A]+)(%a*)", "%4%2%3%1%5") or ""
