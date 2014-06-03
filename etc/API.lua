assert(arg[1] == _apiver, "API did not load")

--[[
  API 1.0:
    The default API.
  API 1.1:
    Remove getUserFS
    Remove getRootFS
    io, os, io.fs switches to root FS.
--]]
