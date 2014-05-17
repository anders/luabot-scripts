-- Usage: interactive_setup_apikey_fs <nick> <apikeyname>

local io = assert(godloadstring("return io"))()

if arg[1] and arg[1]:sub(1, 6) == "-allow" then
  local ckeyallow = "_isaf.-allow." .. nick
  local orignick = Cache[ckeyallow]
  if not orignick then
    return false, nick .. " * -allow not expected at this time"
  end
  Cache[ckeyallow] = nil
  local ckey = "_isaf." .. orignick .. "." .. nick
  local apikey = Cache[ckey]
  if not apikey then
    return false, "Found info but couldn't find the apikey, sry looks like it broke"
  end
  Cache[ckey] = nil
  local apikeypath = Cache[ckey .. ".akp"]
  if not apikey then
    return false, "Found info but couldn't find the apikeypath, sry looks like it broke"
  end
  Cache[ckey .. ".akp"] = nil
  io.fs.mkdir("apikeys")
  assert(etc.setup_apikey_fs(io, nil, apikeypath, apikey))
  print("apikey synced! now use check_apikey_fs(io1, io2, '" .. apikeypath .. "')")
  return
end

do
  assert(arg[1] and arg[1] ~= nick, "Give me someone's nick")
  local seena, seenb = seen(arg[1])
  assert(seena, seenb)
  
  local apikeypath = "apikeys/" .. assert(arg[2], "need apikeyname")
  
  local ckey = "_isaf." .. nick .. "." .. arg[1]
  local apikey = etc.make_apikey(ckey, io, seena)
  Cache[ckey] = apikey
  
  local ckeyallow = "_isaf.-allow." .. arg[1]
  if Cache[ckeyallow] then
    return false, arg[1] .. " is already waiting on another apikey, please try again in a minute"
  end
  Cache[ckeyallow] = nick
  
  io.fs.mkdir("apikeys")
  local safa, safb = etc.setup_apikey_fs(io, nil, apikeypath, apikey)
  if not safa then
    Cache[ckey] = nil
    Cache[ckeyallow] = nil
    assert(safa, safb)
  end
  
  Cache[ckey .. ".akp"] = apikeypath
  
  print(nick .. " * apikey setup in progress, now need " .. arg[1] .. " to type 'interactive_setup_apikey_fs -allow (20 seconds)")
  sleep(20)
  if Cache[ckey] then
    Cache[ckey] = nil
    Cache[ckeyallow] = nil
    Cache[ckey .. ".akp"] = nil
    print("Timeout, apikey not set")
    assert(io.fs.remove(apikeypath))
  end
end
