-- Usage: Foo = etc.class(); function Foo:hello() return 'hello' end; Bar = class(Foo); local obj = Bar(); print(Bar:hello());

local base = arg[1]
local init = arg[2]

local c = {}	 -- a new class instance
if not init and type(base) == 'function' then
    init = base
    base = nil
elseif type(base) == 'table' then
 -- our new class is a shallow copy of the base class!
    for i,v in pairs(base) do
        c[i] = v
    end
    c._base = base
end
-- the class will be the metatable for all its objects,
-- and they will look up their methods in it.
c.__index = c
-- expose a constructor which can be called by <classname>(<args>)
local mt = {}
mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj, c)
    if class_tbl.init then
        class_tbl.init(obj, ...)
    else
        -- if no init, call the base one.
        if base and base.init then
            base.init(obj, ...)
        end
    end
    return obj
end
if init then
    c.init = init
end
c.is_a = function(self, klass)
    local m = getmetatable(self)
    while m do
        if m == klass then return true end
        m = m._base
    end
    return false
end
setmetatable(c, mt)
return c

