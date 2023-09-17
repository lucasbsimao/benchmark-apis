#!/bin/bash

docker compose up -d

echo $(docker compose ps | awk 'NR==2 {print $1}')