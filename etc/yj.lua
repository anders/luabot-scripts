return (arg[1]:gsub('%a+', (function() local x = 'j' return function(c) x = x == 'j' and 'y' or 'j' return c..x end end)()))