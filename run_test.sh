#!/bin/bash

EXEC_PID=""
TRACK_PID=""

USE_STABLE_STATE=$1


function killProccesses {
    echo "Killing processes..."
    
    if [ -n "$TRACK_PID" ]; then
        kill -9 "$TRACK_PID"
    fi

    if [ -n "$EXEC_PID" ]; then
        kill -9 "$EXEC_PID"
    fi
}

function cleanup {
    echo "Cleaning up..."

    killProccesses
    
    exit 0
}

function setup {
    echo "Starting setup..."

    local PORT=8080
    local PORT_PID=$(lsof -t -i :$PORT)

    if [ -n "$PORT_PID" ]; then
        echo "Port $PORT is in use by process $PORT_PID. Exiting..."
        exit 1
    fi

    npm i > /dev/null 2>&1
    cp txt /tmp/
}

function runPlotUsage {
    
    if [ ! -d "benchmark" ]; then
        python3 -m venv benchmark

        source benchmark/bin/activate

        pip install matplotlib
    
    else
        source benchmark/bin/activate
    fi

    python3 plot_usage_graphs.py "$languageChoice"
}

function checkCpuStability {
    current_cpu_usage=$(ps -p $EXEC_PID -o %cpu | tail -n 1)

    [ "$last_cpu_usage" == "0" ] && last_cpu_usage=$current_cpu_usage

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

if abs(float(current_cpu_usage) - float(last_cpu_usage)) < 1.0:
    sys.exit(1)
else:
    sys.exit(0)
END

    if [ $? -eq 1 ]; then
        ((consecutive_cycles++))
    else
        consecutive_cycles=0
    fi

    last_cpu_usage=$current_cpu_usage
}

function waitForAppToStabilize {
    if [ -z "$USE_STABLE_STATE" ] || [ "$USE_STABLE_STATE" -ge 1 ]; then
        continue
    else
        echo "Skipping stabilization phase..."
        return
    fi

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
            echo "App running with PID: $EXEC_PID, waiting CPU ($last_cpu_usage %) to stabilize"
            
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
        echo "App did not reach stable state properly within the timeout period."
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
        USAGE=$(sh -c "ps -p $EXEC_PID -o %cpu,%mem | awk 'NR==2 {print \$1\",\"\$2}'")
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

    EXEC_PID=$!

    echo "App starting with PID: $EXEC_PID"
}

function runNodeApp {
    echo "Executing Node app..."
    
    cd nodejs && npm i
    npm run build
    npm run start:prod 2>&1 &
    cd ..

    while [ -z $EXEC_PID ]; do
        EXEC_PID=$(ps aux | grep "node dist/main" | grep -v "grep" | grep -v "sh -c" | awk '{print $2}')
        sleep 1
    done

    echo "App starting with PID: $EXEC_PID"
}

function runGoApp {
    echo "Executing Go app..."
    
    cd go && go get .
    go build main.go
    ./main >/dev/null 2>&1 &
    cd ..

    EXEC_PID=$!

    echo "App starting with PID: $EXEC_PID"
}

function runKotlinApp {
    echo "Executing Kotlin app..."
    
    cd kotlin && ./gradlew build
    java -jar app/build/libs/app.jar > /dev/null 2>&1 &
    cd ..

    EXEC_PID=$!

    echo "App starting with PID: $EXEC_PID"
}

function main {
    trap 'if [ $? -ge 2 ]; then cleanup $?; fi' EXIT SIGINT
    setup

    PS3="Choose a language to run the benchmark: "
    options=("java" "nodejs" "go" "kotlin")

select choice in "${options[@]}"; do
    case $REPLY in
        1)
            runJavaApp
            languageChoice="${options[$REPLY-1]}"
            break
            ;;
        2)
            runNodeApp
            languageChoice="${options[$REPLY-1]}"
            break
            ;;
        3)
            runGoApp
            languageChoice="${options[$REPLY-1]}"
            break
            ;;
        4)
            runKotlinApp
            languageChoice="${options[$REPLY-1]}"
            break
            ;;
        *)
            echo "Invalid option, please choose a valid number."
            ;;
    esac
done
    if [ $? -ne 0 ]; then
        echo "Error: App start up failed."
        exit 2
    fi

    waitForAppToStabilize

    if [ $? -ne 0 ]; then
        echo "Error: App trial to stabilization failed."
        exit 2
    fi
    
    runBenchmark
    killProccesses

    runPlotUsage
}

main