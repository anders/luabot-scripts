API "1.1"
-- Usage: etc.expireFiles(io, dir, seconds_old)

local LOG = plugin.log(_funcname);

local io, dir, seconds_old = ...

local now = os.time()
io.fs.list(dir, function(fp)
  local fmod = io.fs.attributes(fp, 'modification')
  if fmod then
    local age = now - fmod
    if fmod and age >= seconds_old then
      LOG.info("Expiring", fp, "file.", age, "seconds old.")
      io.fs.remove(fp)
    end
  end
end)
