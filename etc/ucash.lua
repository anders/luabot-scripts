
-- Get amount of cash for the provided currency.
-- Set your own currency symbol using cmdchar..ucashsymbol

local currency, who = (arg[1] or ""):match("([^ ]+) ?([^ ]*)")
if not currency then
  print("Usage: 'ucash <currency> [<nick>]")
  return
end
if not who or who:len() == 0 then
  who = nick
end
local a, b, c = ucashInfo(currency)
print(who .. " has " .. a .. (ucash(who, currency) or 0))
