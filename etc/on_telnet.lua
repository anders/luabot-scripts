if require("spam").detect(Cache, "telnet" .. Telnet.userAddress, 4, 2) then
  print("go outside")
  Telnet.disconnect()
end
if Telnet.line then
  if Telnet.line:sub(1, #etc.cmdprefix) == etc.cmdprefix then
    local cmdline = Telnet.line:sub(#etc.cmdprefix + 1)
    local cmd, params = cmdline:match("([^ ]+) ?(.*)")
    _guest()
    local f, err = guestloadstring("singleprint(etc.on_cmd(...) or '')")
    if not f then
      print("Failed:", err)
    else
      local a, b = pcall(f, cmd, params)
      if not a then
        print("Failed:", b)
      end
    end
  elseif Telnet.line == "quit" or Telnet.line == "exit" then
    print("bye")
    Telnet.disconnect()
  else
    print("Don't know what to do with that: " .. Telnet.line)
  end
else
  print("Hello!")
end
print("----")
