API "1.1"

-- http://spoonerize.com/
--[[
------WebKitFormBoundary9YCdXVWOVE7A94O0
Content-Disposition: form-data; name="string"

gay boy give me my money
------WebKitFormBoundary9YCdXVWOVE7A94O0
Content-Disposition: form-data; name="wordLength"

2
------WebKitFormBoundary9YCdXVWOVE7A94O0
Content-Disposition: form-data; name="wordDistance"

3
------WebKitFormBoundary9YCdXVWOVE7A94O0
Content-Disposition: form-data; name="blacklistOn"

Yes
------WebKitFormBoundary9YCdXVWOVE7A94O0
Content-Disposition: form-data; name="Submit"

Spoonerize!
------WebKitFormBoundary9YCdXVWOVE7A94O0--
]]

--[[
<div class="headline">Here's Your Spoonerism!</div>
            <br />

bay goy mive me my goney            <br /><br />
            <hr />
            <table>
            ]]

local options = {
  string = arg[1] or "you should have given me a string to work with!",
  wordLength = 2,
  wordDistance = 3,
  blacklistOn = "Yes",
  Submit = "Spoonerize!",
}

local post_data = {}
for k, v in pairs(options) do
  post_data[#post_data + 1] = urlEncode(k).."="..urlEncode(tostring(v))
end
post_data = table.concat(post_data, "&")

local resp = assert(httpPost("http://spoonerize.com/process.php", post_data))
local spoonerized = resp:match("Spoonerism!</div><br%s*/?>%s*([^<]+)<br")
return spoonerized
