-- Usage: 'somecommand |'tokens $1- $2 $3 etc
-- $$n means required and will error if nil, $n is optional

local argstr = assert(arg[1], 'token string expected')
local cmdline = argstr
local input = ''
if Input.piped then
  cmdline = argstr:sub(Input.piped + 1)
  input = argstr:sub(1, Input.piped)
end

local function mIRC(line, toks)
  local t = {}
  for w in line:gmatch('[^%s]+') do
    t[#t + 1] = w
  end
  
  return (toks:gsub('(%$%$?)(%d+)(%-?)(%d*)', function(prefix, from, dash, to)
    local required = prefix == '$$'
    local tmp = {}
  
    local orig = prefix..from..dash..to
  
    from, to = tonumber(from), tonumber(to)
    to = to or (dash == '-' and #t) or from
    assert(to >= from, 'expected: '..prefix..'x-y where x<=y')
    
    if from == 0 then
      assert(dash == '', 'invalid token format ($0 is number of tokens)')
      return #t
    end
  
    for i=from, to do
      if required then assert(t[i], 'required arg '..i..' ('..orig..') missing') end
  
      tmp[#tmp + 1] = t[i]
    end
  
    return table.concat(tmp, ' ')
  end):gsub(' %$%+ ', ''))
end

local tmp = {}

for line in input:gmatch('[^\n]+') do
  tmp[#tmp + 1] = mIRC(line, cmdline)
end

return table.concat(tmp, '\n')
