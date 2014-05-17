return "Hello, "
    .. (nick or "nil")
    .. ", welcome to "
    .. (chan or "nil")
    .. " along with "
    .. (names() or "nil")
