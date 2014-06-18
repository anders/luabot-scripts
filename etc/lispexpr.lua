-- evaluates a lisp expression and prints its output
-- uses the lisp from etc.lisp

if not arg[1] then
    etc.printf('$BUsage:$B \'lispexpr expression')
    return nil
end

return etc.lisp("(print " .. arg[1] .. ")")
