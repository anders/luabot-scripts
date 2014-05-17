Output = Output or {}
Output.maxLines = 0
Input = Input or {}
Input.maxLines = 0
if type(arg[1]) == "function" then
  etc.getOutput(arg[1])
end
-- Do nothing with piped-in data.
-- os.exit()
