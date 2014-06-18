local json = require 'json'

print(etc.t(json.decode[[
{
  "a": "b",
  "c": "\u1234\ufffd"
}
]]))
