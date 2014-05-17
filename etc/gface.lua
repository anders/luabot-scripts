if not arg[1] then return "( ≖‿≖)" end

return (table.concat(arg, " "):gsub("(g+)(%s*)(f+)(%s*)(a+)(%s*)(c+)(%s*)(e+)",
    function(gs, a, fs, b, as, c, cs, d, es)
        return ("("):rep(#gs) .. " "
            .. a .. ("≖"):rep(#fs) .. b .. ("‿"):rep(#as)
            .. c .. ("≖"):rep(#cs) .. d .. (")"):rep(#es)
    end))