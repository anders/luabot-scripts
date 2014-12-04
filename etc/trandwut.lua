API "1.1"

Input.piped = Input.piped or #arg[1]

assert(Input.piped, "need some input to transform")

local wut = arg[1]:sub(1, Input.piped)

local tr = etc.getOutput(etc.tr, wut)

print(tr)
print("original was: "..wut)
