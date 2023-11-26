FROM alpine:3.18.4
RUN mkdir -p /data/temp; mkdir -p /etc/sensible/scripts; mkdir -p /var/log/sensible
COPY ./scripts /etc/sensible/scripts
COPY ./settings.yaml /etc/sensible/settings.yaml
COPY ./data /data
RUN chmod -R 777 /data/temp
RUN chmod -R 777 /etc/sensible
RUN wget https://github.com/TheTinkerDad/sensible/releases/download/v0.2.0/sensible-linux-amd64-0.2.0.tar.gz
RUN tar -xf sensible-linux-amd64-0.2.0.tar.gz
RUN mv sensible /usr/local/bin/sensible
RUN chmod a+x /usr/local/bin/sensible
CMD sensible
