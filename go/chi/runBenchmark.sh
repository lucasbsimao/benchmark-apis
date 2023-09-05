#!/bin/bash

go get .
go build main.go
./main >/dev/null 2>&1 &

echo $!