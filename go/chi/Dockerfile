FROM golang:1.20.7-alpine3.18

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN go get .
RUN go build main.go

CMD ./main