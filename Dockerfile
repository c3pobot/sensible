FROM node:20-alpine AS builder
COPY package*.json ./
RUN npm install --omit=dev

FROM node:20-alpine AS app
WORKDIR /app
COPY --from=builder node_modules node_modules/
COPY . .
RUN apk update && \
  # wrap process in --init in order to handle kernel signals
  # https://github.com/krallin/tini#using-tini
  apk add --no-cache tini && \
  rm -rf /var/cache/apk/*
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "node", "index.js" ]
