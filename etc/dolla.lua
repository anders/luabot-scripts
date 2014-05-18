assert(not arg[1] or #tostring(arg[1]) == 1, "Give me 1 byte please")
return "\002\0030,3[̲̅$̲̅(̲̅" .. (arg[1] or "1") .. "̲̅)̲̅$̲̅]\003\002"
