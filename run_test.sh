#!/bin/bash

set -e

EXEC_PID=""

function executeJavaCode {
    echo "Executing Java benchmark..."
    cd java && ./gradlew build
    java -jar app/build/libs/app.jar > /dev/null 2>&1 &

    EXEC_PID=$!

    waitForAppToStart
}

function waitForAppToStart {
    echo "Waiting for app to start..."
    local APP_URL="http://localhost:8080/benchmark"
    local MAX_WAIT_SECONDS=60
    local WAIT_INTERVAL=5
    local TIMEOUT=false

    for ((i = 0; i < MAX_WAIT_SECONDS; i += WAIT_INTERVAL)); do
        response=$(curl -s "$APP_URL")

        if [ "$response" == "OK" ]; then
            echo "App started."
            return
        fi
        sleep $WAIT_INTERVAL
    done

    if [ "$response" != "OK" ]; then
        echo "App did not start properly within the timeout period."
        kill -9 $EXEC_PID
        exit 1
    fi
}

PS3="Choose a language to run the benchmark: "
options=("Java" "Node.js" "Go" "Kotlin")

select choice in "${options[@]}"; do
    case $REPLY in
        1)
            executeJavaCode
            kill -9 $EXEC_PID
            # Add your Java code here
            break
            ;;
        2)
            echo "You selected Node.js"
            # Add your Node.js code here
            break
            ;;
        3)
            echo "You selected Go"
            # Add your Go code here
            break
            ;;
        4)
            echo "You selected Kotlin"
            # Add your Kotlin code here
            break
            ;;
        *)
            echo "Invalid option, please choose a valid number."
            ;;
    esac
done