API "1.1"
-- Get numeric age, or nil

return tonumber(tostring(etc.getOutput(etc.age, ...)):match("(%d+) years"))
