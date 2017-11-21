
line = ""
count=1
list_access = Array.new
while (line != nil) do
  line = STDIN.gets
  next if (dst_port == nil)
  next if (dst_port.index("53") != 0) # your ip address

  p line

  count += 1
end

