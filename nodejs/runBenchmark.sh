#!/bin/bash

npm i
npm run build
npm run start:prod > /dev/null 2>&1 &

while [ -z $EXEC_PID ]; do
    EXEC_PID=$(ps aux | grep "node dist/main" | grep -v "grep" | grep -v "sh -c" | awk '{print $2}')
    sleep 1
done

echo $EXEC_PID