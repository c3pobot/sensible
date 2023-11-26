FROM node:20-alpine AS builder
COPY package*.json ./
RUN npm install --omit=dev

FROM node:20-alpine AS app
WORKDIR /app
COPY --from=builder node_modules node_modules/
COPY . .
CMD [ "node", "index.js" ]
