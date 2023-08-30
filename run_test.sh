#!/bin/bash

EXEC_PID=""
TRACK_PID=""

function cleanup {
    echo "Cleaning up..."
    
    if [ -n "$TRACK_PID" ]; then
        kill -9 "$TRACK_PID"
    fi

    if [ -n "$EXEC_PID" ]; then
        kill -9 "$EXEC_PID"
    fi

    rm -f "$LOCK_FILE"

    exit 0
}

function setup {
    echo "Starting setup..."

    npm i > /dev/null 2>&1
    cp txt /tmp/
}

function checkCpuStability {
    current_cpu_usage=$(ps -p $EXEC_PID -o %cpu | tail -n 1)
            
    [ $last_cpu_usage -eq 0 ] && last_cpu_usage=$current_cpu_usage

    if command -v python &>/dev/null; then
        python_cmd="python"
    elif command -v python3 &>/dev/null; then
        python_cmd="python3"
    fi

    # Use Python for floating-point comparison
    $python_cmd - <<END
import sys

current_cpu_usage = $current_cpu_usage
last_cpu_usage = $last_cpu_usage

if abs(current_cpu_usage - last_cpu_usage) > 1.0:
    sys.exit(1)
else:
    sys.exit(0)
END

    if [ $? -eq 1 ]; then
        ((consecutive_cycles++))
    else
        consecutive_cycles=0
    fi
}

function waitForAppToStabilize {
    echo "Waiting for app to stabilize..."
    local APP_URL="http://localhost:8080/benchmark?n=1"
    local MAX_WAIT_SECONDS=60
    local WAIT_INTERVAL=5
    local TIMEOUT=false

    last_cpu_usage=0
    consecutive_cycles=0
    stable_threshold=3

    for ((i = 0; i < MAX_WAIT_SECONDS; i += WAIT_INTERVAL)); do
        response=$(curl -sf "$APP_URL")

        if [ "$response" == "OK" ]; then
            echo "App started with PID: $EXEC_PID, waiting CPU to stabilize..."
            
            checkCpuStability

            # If consecutive_cycles reaches the stable_threshold, consider it stable
            if [ "$consecutive_cycles" -ge "$stable_threshold" ]; then
                echo "CPU usage has stabilized. Starting the benchmark."
                return
            fi
        fi

        sleep $WAIT_INTERVAL
    done

    if [ "$response" != "OK" ]; then
        echo "App did not start properly within the timeout period."
        kill -9 $EXEC_PID
        exit 1
    fi
}

function runBenchmark {
    OUTPUT_FILE=output.csv
    LOCK_FILE=output.lock

    if [ -f "$OUTPUT_FILE" ]; then
        rm $OUTPUT_FILE
    fi

    while true; do
        USAGE=$(sh -c "ps -p $EXEC_PID -o %cpu,%mem | awk 'NR==2 {print \$1\",\"\$2\";\"}'")
        echo "$SECONDS,$USAGE" >> "$OUTPUT_FILE"
        sleep 1
    done &

    TRACK_PID=$!
    echo "Starting CPU and RAM tracking with PID: $TRACK_PID"
    npm run start

    waitForAppToStabilize
}

function runJavaApp {
    echo "Executing Java app..."
    
    cd java && ./gradlew build
    java -jar app/build/libs/app.jar > /dev/null 2>&1 &
    cd ..

    if [ $? -ne 0 ]; then
        echo "Error: Java build failed."
        exit 1
    fi

    EXEC_PID=$!
}

function main {
    trap cleanup EXIT SIGINT
    setup

    PS3="Choose a language to run the benchmark: "
    options=("Java" "Node.js" "Go" "Kotlin")

select choice in "${options[@]}"; do
    case $REPLY in
        1)
            runJavaApp
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

    waitForAppToStabilize

    if [ $? -ne 0 ]; then
        echo "Error: App trial to stabilization failed."
        exit 2
    fi
    
    runBenchmark
    cleanup
done

}

main