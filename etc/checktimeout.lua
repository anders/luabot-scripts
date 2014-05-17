local watch = stopwatch()
watch:start()
print("BEGIN", os.clock(), os.time())
for i=0,math.huge do
  watch:stop()
  atTimeout("END " .. os.clock() .. " " .. os.time() .. " (elapsed=" .. watch:elapsed() .. ")")
  watch:start()
end
