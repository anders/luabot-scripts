-- Scalable storage into a directory using multiple files.

--[[
require "storage"
local obj = storage.load(io, "my.store")
obj.foo = "bar"
storage.save(obj)
--]]

-- storage.length(obj) = length of table portion; #obj is only what's currently loaded.

-- Note: don't use table.* functions, such as table.insert, or the it won't be saved.

-- Uses the first 3 bytes of the key to determine which file to store it in.


local _M = {}

local MT = {}


function _M.load(io, name, ver)
 if name:byte(1) ~= 47 then
   -- If not leading slash, relative to /home/storage.
   io.fs.mkdir("/home/storage/")
   name = "/home/storage/" .. name
 end
 if io.fs then
   io = io.fs
 end
 io._fast = true
 -- Do this so we can fail early:
 io.mkdir(name)
 local a = io.attributes(name)
 assert(a and a.mode == "directory", "plugin.storage: not a plugin.storage location: " .. name)
 local t = {}
 local mt = {}
 for k, v in pairs(MT) do
   mt[k] = v
 end
 mt.name = name
 mt.io = io
 mt.t = t
 mt.ver = ver or 3
 assert(mt.ver == 2 or mt.ver == 3, "Bad version");
 local st = {}
 setmetatable(st, mt)
 setmetatable(t, mt)
 return st
end


local entry -- forward decl
local entrytable
local writetable
local estring
local epath
local eload
local fexists


function _M.save(st)
  local mt = getmetatable(st)
  local t = mt.t
  if mt.dirty then
    local info = {}
    for k, dirt in pairs(mt.dirty) do
      local path = epath(t, k)
      local x = info[path]
      if not x then
        x = {}
        info[path] = x
      end
      x.rewrite = x.rewrite or (dirt == 'd' or dirt == 'c')
    end
    for path, x in pairs(info) do
      if x.rewrite then
        x.f = assert(mt.io.open(path .. ".tmp", "w"))
      else
        -- Append directly...
        x.f = assert(mt.io.open(path, "a"))
      end
    end
    for k, v in pairs(t) do
      local path = epath(t, k)
      local x = info[path]
      if x then
        if (x.rewrite or mt.dirty[k]) and mt.dirty[k] ~= 'd' then
          x.any = true
          -- write to x.f
          if type(k) == "number" then
            x.f:write(k, "=")
          elseif type(k) == "string" then
            if k ~= "nan" and k:find("^%a[%a%d_%.]*$") then
              x.f:write(k, "=")
            else
              x.f:write("[", estring(k), "]=")
            end
          else
            assert(false, "unexpected key type")
          end
          if type(v) == "number" then
            x.f:write(v, "\n")
          elseif type(v) == "string" then
            x.f:write(estring(v), "\n")
          elseif type(v) == "table" then
            writetable(v, x.f)
            x.f:write("\n")
          else
            -- Handles true/false/nan
            x.f:write(tostring(v), "\n")
          end
        end
      end
    end
    -- Close the files, and all the rewrite ones need to swap files:
    for path, x in pairs(info) do
      x.f:close()
      if x.rewrite then
        -- Swap rewritten files:
        mt.io.remove(path)
        if x.any then
          mt.io.rename(path .. ".tmp", path)
        else
          mt.io.remove(path .. ".tmp")
        end
      end
    end
    mt.dirty = nil
  end
  return true
end


-- Get length of table portion from storage as needed.
function _M.length(st)
  -- Find largest numbered storage file:
  local mt = getmetatable(st)
  if not mt or not mt.name then
    if mt and mt.__len then
      return mt.__len(st)
    end
    return #st
  end
  local t = mt.t
  if not mt.lenloaded then
    local maxpath
    local maxpathstrlen = -1
    local maxpathnum = -1
    os.glob(mt.name .. "/#*.s", function(path)
      local strlen = path:len()
      if strlen >= maxpathstrlen then
        local pathnum = tonumber(path:match("/#(%d+)%.s$")) or -1
        -- print("storage.length", "checking path", path, pathnum)
        if pathnum > maxpathnum then
          maxpath = path
          maxpathstrlen = strlen
          maxpathnum = pathnum
        end
      end
    end)
    if maxpath then
      -- Load it:
      eload(t, maxpath)
    end
    mt.lenloaded = true
  end
  -- Now find the largest numbered index in the loaded table:
  local mn = 0
  for k, v in pairs(t) do
    if type(k) == "number" and k > mn and math.floor(k) == k then
      mn = k
    end
  end
  return mn
end


local function ownchild(t, k, parent, ckey, child)
  local x = t[k]
  if x then
    -- if child is t[k] then the mt will be set.
    local mt = getmetatable(x) or {}
    if not mt.owned then
      mt.owned = {
        __newindex = function(t, k, v)
          local mtc = getmetatable(t)
          -- print("owned newindex " .. tostring(mt.owned.t[mt.owned.k]))
          if mt.owned.t[mt.owned.k] ~= nil then
            local mainMT = getmetatable(mt.owned.t)
            if not mainMT.dirty then
              mainMT.dirty = {}
            end
            if mainMT.dirty[mt.owned.k] == nil then
              mainMT.dirty[mt.owned.k] = 'c'
            end
            rawset(t, k, v)
            if type(v) == "table" then
              ownchild(mt.owned.t, mt.owned.k, t, k, v)
            end
          end
          rawset(mtc.tc, k, v)
        end,
        __index = function(t, k)
          local mtc = getmetatable(t)
          return rawget(mtc.tc, k)
        end,
        __pairs = function(t)
          local mtc = getmetatable(t)
          return next, mtc.tc, nil
        end,
        __len = function(t)
          local maxn = 0
          local mtc = getmetatable(t)
          for k, v in pairs(mtc.tc) do
            if type(k) == "number" and k > maxn and k == math.floor(k) then
              maxn = k
            else
              -- print("not", tostring(k), type(k))
            end
          end
          return maxn
        end,
      }
      mt.owned.t = t
      mt.owned.k = k
    end
    if not getmetatable(child) then
      -- setmetatable(child, mt.owned)
      local mtc = {}
      for k, v in pairs(mt.owned) do
        mtc[k] = v
      end
      mtc.tc = child
      local rt = {}
      setmetatable(rt, mtc)
      rawset(parent, ckey, rt)
    end
    for a, b in pairs(child) do
      if type(b) == "table" then
        -- print("found child " .. tostring(b))
        ownchild(t, k, child, a, b)
      end
    end
  else
    error("ownchild on missing element " .. tostring(k))
  end
end


function MT.__index(st, k)
 if type(k) == "number" then
   --
 elseif type(k) == "string" then
   --
 else
   error("plugin.storage: unexpected storage key of type " .. type(k))
 end
 local mt = getmetatable(st)
 local t = mt.t
 local rr = rawget(t, k)
 if rr then
   return rr
 end
 local path = epath(t, k)
 if not mt.loaded or not mt.loaded[path] then
   eload(t, path)
   if not mt.loaded then
     mt.loaded = {}
   end
   mt.loaded[path] = true
 end
 return rawget(t, k)
end


function MT.__newindex(st, k, v)
 if type(k) == "number" then
   --
 elseif type(k) == "string" then
   --
 else
   error("plugin.storage: unexpected storage key of type " .. type(k))
 end
 local mt = getmetatable(st)
 local t = mt.t
 if not mt.dirty then
   mt.dirty = {}
 end
 -- Keep track of HOW it's dirty, it saves a lot of time when saving.
 -- e.g. delete, vs update, vs new.
 -- Note: also need to keep track of multiple updates, 1 new and 2 update is still new.
 -- local oldv = rawget(t, k)
 local oldv = st[k] -- This might trigger a load, but it's the only way to check.
 local olddirty = mt.dirty[k]
 if v == nil and oldv ~= nil then
   if olddirty == 'n' then
     mt.dirty[k] = nil
   else
     mt.dirty[k] = 'd'
   end
 elseif v ~= nil then
   if oldv == nil then
     mt.dirty[k] = 'n'
   else
     if olddirty ~= 'n' then
       mt.dirty[k] = 'c'
     end
   end
 end
 -- print("~~", mt.dirty[k])
 rawset(t, k, v)
 if type(v) == "table" then
   ownchild(t, k, t, k, v)
 end
end


function epath(t, k)
  local mt = getmetatable(t)
  if type(k) == "number" then
    if k >= 0 and k == math.floor(k) then
      return mt.name .. "/#" .. math.floor(k / 10) .. ".s"
    else
      s = tostring(s)
    end
  elseif type(k) == "string" then
    --
  else
    assert(false, "Invalid type in epath (plugin.storage)")
  end
  -- String:
  local x = k:sub(1, 3):gsub("[^%a%d_]", function(q)
    return bit.tohex(q:byte(), 2)
  end):lower()
  -- Combine 1 and 2-char keys:
  if x:len() == 1 then
    x = "_"
  elseif x:len() == 2 then
    if mt.ver == 2 then
      x = x:sub(1, 2) .. "_" -- v2
    else
      x = x:sub(1, 1) .. "_" -- v3
    end
  elseif x:len() == 3 then
    if mt.ver ~= 2 then
      x = x:sub(1, 2) .. "_" -- v3
    end
  end
  return mt.name .. "/" .. x .. ".s"
end


-- path must already be a valid epath
function eload(t, path)
  local mt = getmetatable(t)
  local f = mt.io.open(path)
  if not f then
    return false, "File not found"
  end
  while true do
    local line = f:read()
    if not line then
      break
    end
    local a, b = line:match("^([%a%d_%.]*)=([%d%-\"{].*)$")
    if a and b then
      -- Note: can't store string key "[%d%.]+" or "nan" this way, conflicts with numbers.
      local bx = b:byte(1) -- Check value type:
      if bx == 34 then -- string
        local s = b:match("^\"([^\\]*)\"$")
        if not s then
          -- Found escapes, need to load as lua.
          s = assert(safeloadstring("return " .. b))()
        end
        b = s
      elseif bx == 123 then -- table
        -- Load as lua.
        -- b = assert(safeloadstring("return " .. b))()
        local xf, xerr = safeloadstring("return " .. b)
        if not xf then
          error("Unable to load storage table from key " .. tostring(a)
            .. "=" .. b .. " because " .. xerr)
        end
        b = xf()
      else -- number
        b = tonumber(b)
      end
      a = tonumber(a) or a
      rawset(t, a, b)
      if type(b) == "table" then
        ownchild(t, a, t, a, b)
      end
    else
      -- More complex, so load as lua.
      local y = assert(safeloadstring("return {" .. line .. "}"))()
      for k, v in pairs(y) do
        rawset(t, k, v)
        if type(v) == "table" then
          ownchild(t, k, t, k, v)
        end
      end
    end
  end
  f:close() -- Added 2013-12-10
  return true
end


function estring(x)
  return string.format("%q", x):gsub("\\\n", "\\n")
end


local function entrytable(k, v, file)
	local ktype = type(k)
	if ktype == "number" then
		file:write("[", k, "]={")
	elseif ktype == "string" then
		-- file:write(string.format("[%q]={", k))
        file:write("[", estring(k), "]={")
	end
	for k2, v2 in pairs(v) do
		entry(k2, v2, file)
	end
	file:write("},")
end


function entry(k, v, file)
	local ktype, vtype = type(k), type(v)
	if vtype == "table" then
		entrytable(k, v, file)
	else
		if ktype == "number" then
			if vtype == "number" then
				file:write("[", k, "]=", v, ",")
			elseif vtype == "string" then
				-- file:write(string.format("[%s]=%q,", k, v))
                -- file:write("[", estring(k), "]=", estring(v), ",") -- key ends up string!
                file:write("[", k, "]=", estring(v), ",")
			end
		elseif ktype == "string" then
			if k:find("^%a[%a%d_]*$") then
				if vtype == "number" then
					file:write(k, "=", v, ",")
				elseif vtype == "string" then
					-- file:write(string.format("%s=%q,", k, v))
                    file:write(k, "=", estring(v), ",")
				end
			else
				if vtype == "number" then
					-- file:write(string.format("[%q]=%s,", k, v))
                    file:write("[", estring(k), "]=", v)
				elseif vtype == "string" then
					-- file:write(string.format("[%q]=%q,", k, v))
                    file:write("[", estring(k), "]=", estring(v), ",")
				end
			end
		end
	end
end


function writetable(t, file)
  file:write("{")
  for k, v in pairs(t) do
    entry(k, v, file)
  end
  file:write("}")
end


return _M
