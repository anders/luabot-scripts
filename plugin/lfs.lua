-- Partial API for luafilesystem.
-- http://keplerproject.github.io/luafilesystem/manual.html#reference

local fs = arg[1]

local M = {}


M.attributes = fs.attributes

M.chdir = fs.chdir

M.lock = function() error("lfs.lock not supported yet"); end

M.unlock = function() error("lfs.unlock not supported yet"); end

M.lock_dir = function() error("lfs.lock_dir not supported yet"); end

M.currentdir = fs.getcwd

function M.dir(path)
  local obj = {}
  obj._x = fs.list(path)
  obj._i = 0
  function obj:next()
    self._i = self._i + 1
    return self._x[self._i]
  end
  function obj:close()
    self._x = nil
    self._i = nil
  end
  return function(obj)
    local r = obj:next()
    if not r then
      obj:close()
    end
    return r
  end, obj
end

M.mkdir = fs.mkdir

M.rmdir = fs.rmdir

function M.setmode()
  return true
end

M.symlinkattributes = M.attributes -- To be improved.

function M.touch(filepath, atime, mtime)
  -- Ignoring the times for now.
  local f, ferr = fs.open(filepath, 'w');
  if not f then
    return f, ferr
  end
  f:close()
  return true
end

return M
