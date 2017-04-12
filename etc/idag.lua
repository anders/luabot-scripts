API "1.1"

local json = require "json"

local now = os.date("!*t")
local url = ("http://api.dryg.net/dagar/v2.1/%04d/%02d/%02d"):format(now.year, now.month, now.day)
local resp = assert(httpGet(url))
local data = json.decode(resp)

local dag = data.dagar[1]
etc.printf("%s (%s, vecka %s) arbetsfri = %s, röd = %s, namnsdag: %s. %s",
  dag.datum, dag.veckodag, dag.vecka, dag["arbetsfri dag"] or "nej", dag["röd dag"] or "nej", table.concat(dag.namnsdag, ", "), dag.helgdag or "-")

