if arg[1] then
    Cache["test_" .. nick] = arg[1]
    print("Done")
else
    print(Cache["test_" .. nick])
end
