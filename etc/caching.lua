local secret = io.open('secret'):read()
if arg[1] ~= secret then
  error('fuck off ;)')
end

return Cache