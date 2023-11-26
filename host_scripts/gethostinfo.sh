#!/bin/sh

df / | tail -n 1 | awk '{printf "%.2f", $3 / 1048576}' > /opt/data/sensible/root_used.txt
df / | tail -n 1 | awk '{printf "%.2f", $4 / 1048576}' > /opt/data/sensible/root_free.txt
cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "%.2f", $0 / 1000}' > /opt/data/sensible/cpu_temp.txt
top -bn1 | awk '/Cpu/ { print $2}' > /opt/data/sensible/cpu_load.txt
hostname -f > hostname.txt
ip route get 8.8.8.8 | head -1 | cut -d' ' -f7 > /opt/data/sensible/ip_address.txt
uptime -s > /opt/data/sensible/boot_time.txt
free | awk '/Mem/ {printf "%.1f", $2 / 1048576}' > /opt/data/sensible/total_mem.txt
free | awk '/Mem/ {printf "%.1f", $3 / 1048576}' > /opt/data/sensible/used_mem.txt
free | awk '/Mem/ {printf "%.1f", $4 / 1048576}' > /opt/data/sensible/free_mem.txt
free | awk '/Mem/ {printf "%.1f", ($3 / $2) * 100}' > /opt/data/sensible/mem_load.txt
