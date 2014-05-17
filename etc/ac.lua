assert(arg[1])

print("World class acronym creator! Thank you for your inputs!!!!")

print("Your acronym is:")

sleep(7)

local ac = ''

local next = true
for i = 1, arg[1]:len() do
  local ch = arg[1]:sub(i, i)
  if ch:find("^[a-zA-Z]$") then
    if next then
      ac = ac .. ch
    end
    next = false
  else
    next = true
  end
end

print(ac:upper())
