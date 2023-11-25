#!/bin/sh
mkdir -p /opt/data/sensible
chmod -R 777 /opt/data/sensible
while true
 do gethostinfo.sh
sleep 5
done
