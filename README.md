# sensible
Host Setup
run
```
curl https://raw.githubusercontent.com/c3pobot/sensible/main/hostinstall.sh | sudo bash
``
or Manual install below
copy files from host_scripts to the host machine
```
nano /usr/local/bin/sensible.sh
```
and
```
nano /usr/local/bin/gethostinfo.sh
```
make scripts executable
```
chmod a+x /usr/local/bin/sensible.sh
chmod a+x /usr/local/bin/gethostinfo.sh
```
create file `/lib/systemd/system/sensible.service` with contents
```
[Unit]
Description=Sensible monitoring service
After=network.target

[Service]
ExecStart=/usr/local/bin/sensible
User=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
Activate service. (make sure the host scripts are exucutable
```
systemctl daemon-reload
systemctl enable sensible.service
systemctl start sensible.service
```

Docker volume mapping
```
/opt/data/sensible:/data
/opt/data/sensible/settings.yaml:/etc/sensible/settings.yaml
```

