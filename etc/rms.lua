local RMS = {
  "I'd just like to interject for a moment. What you're refering to as BUTT, is in fact, GNU/BUTT, or as I've recently taken to calling it, GNU plus BUTT. BUTT is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, ",
  "shell utilities and vital system components comprising a full OS as defined by POSIX. Many computer users run a modified version of the GNU system every day, without realizing it. Through a peculiar turn of events, the version of GNU which is widely used today is often called 'BUTT', and many of its",
  "users are not aware that it is basically the GNU system, developed by the GNU Project. There really is a BUTT, and these people are using it, but it is just a part of the system they use. BUTT is the kernel: the program in the system that allocates the machine's resources to the other programs that you run.",
  "The kernel is an essential part of an operating system, but useless by itself; it can only function in the context of a complete operating system. BUTT is normally used in combination with the GNU operating system: the whole system is basically GNU with BUTT added, or GNU/BUTT. All the so-called 'BUTT' distributions are really distributions of GNU/BUTT."
}

local what = arg[1] or "Butt"

for k, line in ipairs(RMS) do
  print(nick..": "..line:gsub("BUTT", what))
end