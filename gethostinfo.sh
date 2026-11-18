#!/bin/sh

root_used="\"$(df / | tail -n 1 | awk '{printf "%.2f", $3 / 1048576}')\""
root_free="\"$(df / | tail -n 1 | awk '{printf "%.2f", $4 / 1048576}')\""
platform="\"$(uname -m)\""
cpu_load="\"$(top -bn1 | awk '/Cpu/ { print $2}')\""
host_name="\"$(hostname)\""
boot_time="\"$(awk '/btime/ {print $2}' /proc/stat)\""
mem_total="\"$(free | awk '/Mem/ {printf "%.1f", $2 / 1048576}')\""
mem_used="\"$(free | awk '/Mem/ {printf "%.1f", $3 / 1048576}')\""
mem_free="\"$(free | awk '/Mem/ {printf "%.1f", $4 / 1048576}')\""
mem_load="\"$(free | awk '/Mem/ {printf "%.1f", ($3 / $2) * 100}')\""
cat > /opt/data/hostInfo.json <<EOF
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
