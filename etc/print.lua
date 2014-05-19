local LOG = plugin.log(_funcname);

local loadfunc = godloadstring
if not allCodeTrusted() then
  -- Check 'lastlog if guest mode is enabled.
  LOG.warn("Guest mode enabled due to:", whyNotCodeTrusted())
  loadfunc = guestloadstring
end

assert(loadfunc("print(" .. (arg[1] or '') .. ")"))()
