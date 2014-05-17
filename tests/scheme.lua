local scheme = require("scheme")
scheme.util = require("scheme_util")

scheme.run([[
(define func.params
    (table
        [title "Oops, there were errors during startup!"]
        [text "Some error description here"]))
]])

scheme.export()

print(scheme.util.var_dump(func))
