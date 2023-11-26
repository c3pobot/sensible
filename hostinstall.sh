#!/bin/sh

mkdir -p /opt/data/sensible
chmod 777 /opt/data/sensible
uname -m > /opt/data/sensible/platform.txt
echo "Creating /usr/local/bin/gethost.sh..."
cat >  /usr/local/bin/gethostinfo.sh <<'EOF'
#!/bin/sh

df / | tail -n 1 | awk '{printf "%.2f", $3 / 1048576}' > /opt/data/sensible/root_used.txt
df / | tail -n 1 | awk '{printf "%.2f", $4 / 1048576}' > /opt/data/sensible/root_free.txt
cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "%.2f", $0 / 1000}' > /opt/data/sensible/cpu_temp.txt
top -bn1 | awk '/Cpu/ { print $2}' > /opt/data/sensible/cpu_use.txt
hostname -f > hostname.txt
ip route get 8.8.8.8 | head -1 | cut -d' ' -f7 > /opt/data/sensible/ip_address.txt
uptime -s > /opt/data/sensible/boot_time.txt
free | awk '/Mem/ {printf "%.1f", $2 / 1048576}' > /opt/data/sensible/total_mem.txt
free | awk '/Mem/ {printf "%.1f", $3 / 1048576}' > /opt/data/sensible/used_mem.txt
free | awk '/Mem/ {printf "%.1f", $4 / 1048576}' > /opt/data/sensible/free_mem.txt
free | awk '/Mem/ {printf "%.1f", ($3 / $2) * 100}' > /opt/data/sensible/mem_use.txt
EOF

echo "making script executable ..."
chmod a+x /usr/local/bin/gethostinfo.sh

echo "Creating /usr/local/bin/sensible.sh..."
cat > /usr/local/bin/sensible.sh <<EOF
#!/bin/sh

mkdir -p /opt/data/sensible
chmod -R 777 /opt/data/sensible
while true
 do /usr/local/usr/gethostinfo.sh
sleep 5
done
EOF

echo "making script executable..."
chmod a+x /usr/local/bin/sensible.sh

echo "Creating sensible systemd service.."
cat > /lib/systemd/system/sensible.service <<EOF
[Unit]
Description=Sensible monitoring service
After=network.target

[Service]
ExecStart=/usr/local/bin/sensible.sh
User=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "Starting service..."
systemctl daemon-reload
systemctl enable sensible.service
systemctl start sensible.service
systemctl status sensible.service
