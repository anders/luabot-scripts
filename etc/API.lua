-- Usage: API "<number>" on the first line to use a specific API version. See etc.API source for version info.

--[[
  API 1.2:
    Automatically returns any strings printed when etc or other module functions are called.
    Experimental version: this version will stay, but later versions may revert behavior.
  API 1.1:
    Remove getRootFS
    getUserFS updated to use restricted root FS, no longer requires a nickname.
    io, os, io.fs uses root FS.
  API 1.0:
    The original API.
--]]

assert(arg[1] == _apiver, "API did not load")
