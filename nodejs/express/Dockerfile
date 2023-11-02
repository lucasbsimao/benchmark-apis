FROM node:18.17.0-alpine3.18

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN npm i
RUN npm run build

CMD npm run start:prod