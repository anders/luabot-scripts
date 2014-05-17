  local S = require "stringlua"
  local TA = require "stringlua.tablearray" -- strings as tables of chars
  local FA = require "stringlua.filearray"  -- strings as proxy tables to files
  local SA = require "stringlua.stringarray"-- strings as proxy tables to strings
  local s1 = TA {'a','b','c','1','2','3'}
  assert(S.match(s1, SA'%a%d') == TA{'c','1'})

print("all systems go")
