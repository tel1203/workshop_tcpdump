#
# Usage:
#   sudo tcpdump -n -i wlan0 | ruby analysis01.rb 
#

def parse_tcpdump(line)
  data = line.split(" ")

  # Check input data validation, null -> skip
  if (line == nil) then
    return (nil)
  end
  if (data == []) then
    return (nil)
  end

  src = data[2]
  dst = data[4]
  size = data[-1] 

  return if (src == nil or dst == nil)

  tmp1 = src.split(".")
  tmp2 = dst.split(".")
  if (tmp1.length == 5) then
  # IPv4
     src_ip = tmp1[0,4].join(".")
     src_port = tmp1[4]
     dst_ip = tmp2[0,4].join(".")
     dst_port = tmp2[4]
  else
  # IPv6
     src_ip = tmp1[0]
     src_port = tmp1[1]
     dst_ip = tmp2[0]
     dst_port = tmp2[1]
  end

  return ([src_ip, src_port, dst_ip, dst_port, size])
end

line = ""
count=0
while (line != nil) do
  line = STDIN.gets
  src_ip, src_port, dst_ip, dst_port, size = parse_tcpdump(line)
  next if (src_ip == nil)
  next if (src_ip.index("10.0.0") != 0)

  puts(line)

  count += 1
end

