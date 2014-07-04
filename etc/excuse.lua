local dolan = assert(httpGet("http://www.programmerexcuses.com/"))
local _, dolan = dolan:match("<center(.*)>(.-)</a></center>")
return dolan or "xD"

