-- State Machine. Also etc.sm
-- Usage: (Cache, name, argtable, functions...)
-- Returns the state index and whether or not it is the last state.
-- name is a cache name to use.
-- Prefix name with ~ to be local to a user, or with # for local to a channel, or use both.
-- argtable can simply be the arg {...} from a function, passed to the current function.
-- A function can return false to prevent progressing to the next state.
-- A function can also return a number to jump to the next state index on the next call.
-- The initial state index is 0.

local Cache = arg[1]
assert(type(Cache) == "table", "Cache expected")

local name = arg[2]
assert(type(name) == "string", "sm name expected")
name = 'sm.' .. name:gsub("[#~]", function(x)
  if x == '#' then
    if not chan then
      return '#'
    end
    return chan .. '#'
  elseif x == '~' then
    return '~' .. nick .. '~'
  end
end)

local state = Cache[name] or 0
local argtable = arg[3]

local f = arg[4 + state]
if type(f) ~= "function" then
  state = 0
  -- Cache[name] = 0
  f = arg[4 + state]
  assert(f, "No state functions")
end

local timeoutfunc
local canadvancetimeout = true
local islast = type(arg[4 + state + 1]) ~= nil
if type(f) == "function" then
  local x, y
  Cache[name .. ".tx"] = nil
  if argtable then
    x, y = f(unpack(argtable))
  else
    x, y = f()
  end
  if false ~= x then
    if type(x) == "number" then
      state = x
      canadvancetimeout = false
    elseif type(x) == "function" then
      -- Return a function which is called on timeout.
      -- If the timeout function explicitly returns false, the whole state is abandoned.
      -- The timeout function can also return a new state index; or true to auto advance.
      -- The timeout is 20 seconds.
      state = state + 1
      timeoutfunc = x
      canadvancetimeout = false
    else
      state = state + 1
      canadvancetimeout = false
    end
  end
  if type(y) == "function" then
    -- If 2 return values, the first determines what state to change,
    -- and the second one is the timeout function.
    timeoutfunc = y
  end
  Cache[name] = state -- Update, but also keep it fresh (cache expire).
  
  if timeoutfunc then
    local tx = (os.time() - 1380253610) * 100000 + math.random(0, 100000)
    Cache[name .. ".tx"] = tx
    sleep(20)
    if Cache[name .. ".tx"] == tx then
      Cache[name .. ".tx"] = nil
      local x2
      if argtable then
        x2 = timeoutfunc(unpack(argtable))
      else
        x2 = timeoutfunc()
      end
      if x2 == false then
        Cache[name] = nil
      elseif x2 == true then
        if canadvancetimeout then
          -- Only auto advance if it hasn't advanced yet.
          state = state + 1
          canadvancetimeout = nil
        end
      elseif type(x2) == "number" then
        state = x2
      end
    end
    islast = type(arg[4 + state + 1]) ~= nil -- ???
    Cache[name] = state
  end
  
  return state, islast
end

