#!/bin/sh

root_used="\"$(df / | tail -n 1 | awk '{printf "%.2f", $3 / 1048576}')\""
root_free="\"$(df / | tail -n 1 | awk '{printf "%.2f", $4 / 1048576}')\""
cpu_temp="\"$(cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "%.2f", $0 / 1000}')\""
platform="\"$(uname -m)\""
cpu_load="\"$(top -bn1 | awk '/Cpu/ { print $2}')\""
host_name="\"$(hostname -f)\""
ip_address="\"$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)\""
boot_time="\"$(uptime -s)\""
mem_total="\"$(free | awk '/Mem/ {printf "%.1f", $2 / 1048576}')\""
mem_used="\"$(free | awk '/Mem/ {printf "%.1f", $3 / 1048576}')\""
mem_free="\"$(free | awk '/Mem/ {printf "%.1f", $4 / 1048576}')\""
mem_load="\"$(free | awk '/Mem/ {printf "%.1f", ($3 / $2) * 100}')\""
cat > /opt/data/sensible/hostInfo.json <<EOF
[
  {
    "name": "Platform",
    "id": "platform",
    "icon": "mdi:wrench-check",
    "value": $platform
  },
  {
    "name": "Root Used",
    "id": "root_used",
    "icon": "mdi:harddisk",
    "unit": "GB",
    "value": $root_used
  },
  {
    "name": "Root Free",
    "id": "root_free",
    "icon": "mdi:harddisk",
    "unit": "GB",
    "value": $root_free
  },
  {
    "name": "CPU Temp",
    "id": "cpu_temp",
    "icon": "mdi:temperature-celsius",
    "unit": "C",
    "value": $cpu_temp
  },
  {
    "name": "CPU Load",
    "id": "cpu_load",
    "icon": "mdi:cpu-64-bit",
    "unit": "%",
    "value": $cpu_load
  },
  {
    "name": "Hostname",
    "id": "host_name",
    "icon": "mdi:network",
    "value": $host_name
  },
  {
    "name": "Host IP Address",
    "id": "ip_address",
    "icon": "mdi:network",
    "value": $ip_address
  },
  {
    "name": "Boot Time",
    "id": "boot_time",
    "icon": "mdi:network",
    "value": $boot_time
  },
  {
    "name": "Mem Total",
    "id": "mem_total",
    "icon": "mdi:memory",
    "unit": "GB",
    "value": $mem_total
  },
  {
    "name": "Mem Free",
    "id": "mem_free",
    "icon": "mdi:memory",
    "unit": "GB",
    "value": $mem_free
  },
  {
    "name": "Mem Used",
    "id": "mem_used",
    "icon": "mdi:memory",
    "unit": "GB",
    "value": $mem_used
  },
  {
    "name": "Mem Load",
    "id": "mem_load",
    "icon": "mdi:memory",
    "unit": "%",
    "value": $mem_load
  }
]
EOF
