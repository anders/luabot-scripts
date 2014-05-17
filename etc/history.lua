-- Usage: 'history term - search the history for the term.

local origflags
if type(arg[1]) == "table" then
  origflags = arg[1]
  for i = 2, #arg do
    arg[i - 1] = arg[i]
  end
end

local t = {}

local i = 0
local pat = arg[1] or ".*"

local flags = { ['format-no-filename'] = "%s", ['format-with-filename'] = "%f %s" }
if origflags then
  flags = etc.mergeflags(flags, origflags)
end

-- NOTE: you CAN NOT stream the history into grep!
-- Grep's output will mess with the history and cause feedback!
-- So we'll redirect grep's output.
print(etc.getOutput(function()
  etc.grep(flags,
    pat,
    {
      read = function(self, fmt)
        assert(not fmt or fmt:sub(2) == "*l")
        i = i + 1
        local msg, nick, time = _getHistory(i)
        if not msg then
          return nil
        end
        -- self._path = etc.duration(os.time() - time, 1) .. " ago <" .. nick .. ">"
        -- return msg
        self._path = etc.duration(os.time() - time, 1) .. " ago"
        return "<" .. nick .. "> " .. msg
      end;
      lines = function(self)
        return function(self)
          return self:read()
        end, self
      end;
      grepGetFilePath = function(self)
        return self._path
      end;
      grepIsMultiFile = function(self)
        return true
      end;
  })
end))
