----------------------------
-- Simple cache helper    --
-- Written by Anders      --
-- 2012-02-08             --
----------------------------

-- Changelog:
-- 2012-02-11: add "noop" parameter to plugin.cache(), set to True to disable all caching
-- 2012-07-13: add cache.set(key, data, duration)
-- 2014-03-29: auto noop should run callback

-- Constants
local MAX_LINES = 8 -- generous in case it's used to print stuff in the web editor

-- Plugin functions
local _M = {}

-- Private variables
local orig_print = print
local orig_error = error
local cache_key = false
local buffer = {}
local cache_table = assert(arg[1], 'plugin.cache(Cache) required!')
local cache_noop = arg[2] or false

local function cache_set(k, v)
  cache_table[k] = v
end

local function cache_get(k)
  return cache_table[k]
end

-- monkey patch print() to buffer its output
function print(...)
  if not cache_key then
    orig_print(...)
    return
  end

  if #buffer >= MAX_LINES then
    return
  end

  local tmp = {}
  for i=1, select('#', ...) do
    tmp[i] = tostring(select(i, ...))
  end
  tmp = table.concat(tmp, ' ')

  buffer[#buffer + 1] = tmp
end

-- cache.start(cache key, seconds)
-- buffers output
function _M.start(key, duration)
  assert(type(key) == 'string', 'key needs to be specified')
  assert(type(duration) == 'number', 'duration needs to be specified')
  assert(#key > 0, 'key is too short')

  buffer = {}
  cache_key = key
  cache_set(key..'_exp', os.time() + duration)
end

-- cache.stop()
-- stores and flushes output
function _M.stop()
  local data = table.concat(buffer, '\n')
  orig_print(data)
  cache_set(cache_key, data)
  cache_key = nil
end

-- cache.isCached(key)
function _M.isCached(key)
  assert(key, 'key must not be nil')
  if cache_get(key) and cache_get(key..'_exp') then
    if cache_get(key..'_exp') > os.time() then
      return true
    end
  end
  return false
end

-- cache.get(key)
-- returns the cached output
function _M.get(key)
  assert(key, 'key must not be nil')
  return cache_get(key)
end

-- cache.set(key, data, duration)
function _M.set(key, data, duration)
  assert(key, 'key must not be nil')
  assert(data, 'data must not be nil')
  assert(type(duration) == 'number', 'need duration in seconds')
  cache_set(key, data)
  cache_set(key..'_exp', os.time() + duration)
end

-- cache.print(key)
-- prints the cached output
function _M.print(key)
  orig_print(_M.get(key))
end

function _M.auto(key, duration, callback)
  if _M.isCached(key) then
    _M.print(key)
    return true
  else
    _M.start(key, duration)
    callback()
    _M.stop()
  end
end

if not cache_noop then
  return _M
else
  return {
    start = function() end,
    stop = function() end,
    print = function() end,
    isCached = function() end,
    get = function() end,
    set = function() end,
    auto = function(_, _, callback) callback() end
  }
end