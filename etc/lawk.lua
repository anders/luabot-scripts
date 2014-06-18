API "1.1"
-- Usage: similar to awk but for lua.

-- Consider env var IGNORECASE.

local LOG = plugin.log(_funcname);

arg, io.stdin = etc.stdio(arg)
local args = { etc.getArgs(arg) } -- args[1] are flags

-- Syntax, where each part is optional, and can spread across args or group into single arg.
-- lawk "BEGIN { code } search1 { scode1 } search2 { scode2 }  ...  END { code }" file

FPAT = "[^%s]+"

local begincode = nil
local searches = {} -- Array of: array with [1] search and [2] code, search can be nil.
local endcode = nil
local inputs = {} -- List of file paths.

local function getToken(code)
  code = code:gsub("^%s+", "")
  if code == "" then
    return false, "EOF"
  end
  local tok, remain
  tok, remain = code:match("^(%$?[%w_%.]+)%s*(.*)")
  if tok then return tok, remain end
  -- tok, remain = code:match("^([%{%}])%s*(.*)")
  -- if tok then return tok, remain end
  tok, remain = code:match("^(/[^/]*/)%s*(.*)")
  if tok then return tok, remain end
  do
    -- Quoted strings.
    local qchar = code:sub(1, 1)
    if qchar == '"' or qchar == "'" then
      local pos = 2
      local pat = "([\\" .. qchar .. "])"
      while true do
        local m, n, o = code:find(pat, pos)
        if not n then
          LOG.debug("Unterminated string literal", "This can happen with 'funcs")
          return qchar, code:sub(2)
        end
        pos = n
        if o == '\\' then
          pos = pos + 1
        else
          break
        end
      end
      tok = code:sub(1, pos)
      remain = code:sub(pos + 1)
      return tok, remain
    end
  end
  tok, remain = code:match("^(%p)%s*(.*)")
  if tok then return tok, remain end
  -- return assert(nil, "Unable to parse: " .. code)
  return code, ""
end

local filesremain = false
local isarg = false
local iarg = 0
local islastarg = false
local tokcode = ""

local function _moveNextArg()
  assert(tokcode == "")
  iarg = iarg + 1
  LOG.trace("_moveNextArg", iarg)
  isarg = true
  islastarg = not arg[iarg + 1]
  tokcode = arg[iarg]
end

local function nextToken()
  isarg = false
  if tokcode == "" then
    _moveNextArg()
    if not tokcode then
      return false, "EOF"
    end
  end
  local tok
  tok, tokcode = getToken(tokcode)
  LOG.trace("nextToken:", tok)
  LOG.trace("remain:", tokcode)
  assert(tok or islastarg, "Found empty arg")
  return tok
end

local function peekNextChar()
  if tokcode == "" then
    _moveNextArg()
  end
  if tokcode ~= nil then
    return tokcode:sub(1, 1)
  end
end

local function eatArg()
  assert(isarg)
  local whole = arg[iarg]
  tokcode = ""
  return whole
end

local function getCode(firsttok)
  firsttok = firsttok or nextToken()
  if firsttok ~= "{" then
    return assert(nil, "Code expected, found " .. (firsttok or "EOF"))
  end
  local code = { }
  -- Since lua doesn't use { } for code, don't deal with nesting them.
  while true do
    local tok = nextToken()
    if not tok then
      return assert(nil, "Unterminated code, expected }")
    end
    if tok == "}" then
      break
    end
    code[#code + 1] = tok
    if not tok:find("^%p") then
      -- If not punctuation, add token spacing.
      code[#code + 1] = " "
    end
  end
  return table.concat(code, "")
end

-- Depends on _G persisted across loadstrings in same thread.
-- This is a reasonable expectation, as it's already used for print hooking.
local function compile(code, chunkname)
  if not code then
    code = "print($0)"
  end
  code = code:gsub("%$(%d+)", function(sn)
    if sn == "0" then
      return "etc.stringprint(unpack(arg))"
    else
      -- Wrap in parens to disallow assignment...
      return "(arg[" .. sn .. "])"
    end
  end)
  code = "arg=...; \t " .. code
  LOG.trace("Compiling", chunkname or "code", code)
  return assert(guestloadstring(code, chunkname))
end

local function nextPart(firsttok)
  firsttok = firsttok or nextToken()
  if not firsttok then
    return false
  end
  if firsttok == "{" and not filesremain then
    local code = assert(getCode(firsttok))
    LOG.debug("Code:", code)
    searches[#searches + 1] = { "", compile(code, "lawk code") }
  elseif firsttok == "BEGIN" and not filesremain then
    assert(not begincode, "BEGIN already found")
    begincode = compile(assert(getCode()), "lawk BEGIN")
    LOG.debug("BEGIN Code:", begincode)
  elseif firsttok == "END" and not filesremain then
    assert(not endcode, "END already found")
    endcode = compile(assert(getCode()), "lawk END")
    LOG.debug("END Code:", endcode)
  elseif firsttok:sub(1, 1) == '/' then
    -- Pattern.
    local code = false
    if peekNextChar() == '{' then
      code = assert(getCode())
    end
    local pat = firsttok:sub(2, -2)
    LOG.debug("Search:", firsttok)
    LOG.debug("Code:", code)
    searches[#searches + 1] = { pat, compile(code, "lawk pattern") }
  else
    -- File?
    filesremain = true
    assert(isarg, "Unexpected input: " .. firsttok)
    -- Eat the whole arg:
    local fp = eatArg()
    inputs[#inputs + 1] = fp
    LOG.debug("File:", fp)
  end
  return true
end

local function doInput(file)
  LOG.debug("Reading file:", FILENAME)
  FNR = 0
  for line in file:lines() do
    FNR = FNR + 1
    if #searches == 0 then
      print(line)
    else
      for i = 1, #searches do
        if line:find(searches[i][1]) then
          -- LOG.trace("Matched", line)
          local searchargs = { }
          for field in line:gmatch(FPAT) do
            searchargs[#searchargs + 1] = field
          end
          searches[i][2](searchargs)
        end
      end
    end
  end
end

while nextPart() do
end

if begincode then
  begincode()
end

-- Loop through inputs and test searches...
if #inputs == 0 then
  FILENAME = "-"
  doInput(io.stdin)
end
for i = 1, #inputs do
  local fp = inputs[i]
  FILENAME = fp
  if fp == "-" then
    doInput(io.stdin)
  else
    doInput(etc.userfileopen(fp))
  end
end

if endcode then
  endcode()
end
