API "1.1"

return arg[1]:gsub("%s(%a)([^aeiouAEIOU%W])(%w*)(%W+)([^aeiouAEIOU%W])(%w*)", "%4%2%3%1%5") or ""
