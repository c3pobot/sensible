FROM busybox:latest
LABEL org.opencontainers.image.source=https://github.com/c3pobot/sensible
WORKDIR /app

RUN mkdir -p /opt/data

COPY gethostinfo.sh .

RUN chmod +x /app/gethostinfo.sh

CMD ["sh", "-c", "while true; do /app/gethostinfo.sh; sleep 5; done"]
