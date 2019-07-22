API "1.1"

local target = os.time{year=2019, month=8, day=25, hour=0}
local now = os.time()
etc.printf("Dagar kvar: %d", ((target-now)/86400)+0.5)
