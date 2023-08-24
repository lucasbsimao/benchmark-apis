FROM node:18.17.1-alpine

WORKDIR /app

COPY . .

RUN npm install
RUN npm run build

CMD node dist/main.js