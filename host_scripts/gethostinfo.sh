#!/bin/sh
cd /opt/data/info
df / | tail -n 1 | awk '/ / {printf "%.2f", $4 / 1048576}' > root_free.txt
cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "%.2f", $0 / 1000}' > cpu_temp.txt
hostname -f > hostname.txt
ip a s eth0 | awk '/inet / {print$2}' > ip_address.txt
uname -m > platform.txt
uptime -s > boot_time.txt
free | awk '/Mem/ {printf "%.1f", $2 / 1048576}' > total_mem.txt
free | awk '/Mem/ {printf "%.1f", $3 / 1048576}' > used_mem.txt
free | awk '/Mem/ {printf "%.1f", $4 / 1048576}' > free_mem.txt
