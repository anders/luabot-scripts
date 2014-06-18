local a, b, c, uid = _getCallInfo('etc', (arg[1]:match("[^']+")))
assert(uid)

return getname(uid)
