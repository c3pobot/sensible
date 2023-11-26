#!/bin/sh

mkdir -p /opt/data/sensible
chmod -R 777 /opt/data/sensible
while true
 do /usr/local/bin/gethostinfo.sh
sleep 5
done
