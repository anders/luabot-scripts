if Event then
  if Event.recentUser then
    -- Might be a quick rejoin or a netsplit.
    return
  end
  etc.checknotes();
  etc.info();
end
