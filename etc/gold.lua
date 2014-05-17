local value, currency = etc.getOutput(etc.money, '1 XAU '..(arg[1] or '')):match('= ([%d%.]+) (.+)')
print(('Value of gold: %.2f %s / gram'):format(value / 31.1034768, currency))