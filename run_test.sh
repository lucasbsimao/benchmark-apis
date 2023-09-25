#!/bin/bash

CONTAINER_NAME=""
TRACK_PID=""

USE_STABLE_STATE=$1


function cleanUp {
    echo "Cleaning up processes..."

    rm $languageChoice/txt
    
    if [ -n "$TRACK_PID" ]; then
        kill -9 "$TRACK_PID"
    fi

    if [ -n "$CONTAINER_NAME" ]; then
        cd $languageChoice
        docker compose down
        cd -
    fi
}

function cleanUpAndExit {
    echo "Cleaning up and exiting..."

    cleanUp
    
    exit 0
}

function setup {
    echo "Setting up..."

    local PORT=8080
    local PORT_PID=$(lsof -t -i :$PORT)

    if [ -n "$PORT_PID" ]; then
        echo "Port $PORT is in use by process $PORT_PID. Exiting..."
        exit 1
    fi

    if [ ! -d benchmark_graphs ]; then
        mkdir benchmark_graphs
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
    current_cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $CONTAINER_NAME | sed 's/%//g')

    [ "$last_cpu_usage" == "0" ] && last_cpu_usage=$current_cpu_usage

    if command -v python &>/dev/null; then
        python_cmd="python"
    elif command -v python3 &>/dev/null; then
        python_cmd="python3"
    fi

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
    if [ ! -z "$USE_STABLE_STATE" ] && [ ! "$USE_STABLE_STATE" -ge 1 ]; then
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
            echo "App running in containter: $CONTAINER_NAME, waiting CPU ($last_cpu_usage %) to stabilize"
            
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
        cd $languageChoice
        docker compose stop
        cd -
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
        USAGE=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemPerc}}" $CONTAINER_NAME  | sed 's/%//g')
        echo "$SECONDS,$USAGE" >> "$OUTPUT_FILE"
        sleep 0.5
    done &

    TRACK_PID=$!
    echo "Starting CPU and RAM tracking with PID: $TRACK_PID"
    npm run start

    waitForAppToStabilize
}

function startBenchmarkApp {
    options=()
    while IFS= read -r -d $'\0' file; do
        dir=$(dirname "$file")
        relDir=${dir#./}
        options+=("$relDir")
    done < <(find . -name "docker-compose.yaml" -print0)

    PS3="Choose a language to run the benchmark: "

select choice in "${options[@]}"; do
    if [[ " ${options[*]} " == *" $choice "* ]]; then
        echo "Executing $choice app..."

        local OLD_PWD=$(pwd)
        cp txt $choice
        cd $choice

        docker compose up -d
        CONTAINER_NAME=$(docker compose ps | awk 'NR==2 {print $1}')

        cd "$OLD_PWD"

        if [ $? -ne 0 ]; then
            echo "Error: App start up failed."
            exit 2
        fi

        languageChoice="$choice"

        echo "App starting in container: $CONTAINER_NAME"
        break
    else
        echo "Invalid option, please choose a valid number."
    fi
done

}

function main {
    trap 'if [ $? -ge 2 ]; then cleanUpAndExit $?; fi' EXIT SIGINT
    setup

    startBenchmarkApp

    waitForAppToStabilize

    if [ $? -ne 0 ]; then
        echo "Error: App trial to stabilization failed."
        exit 2
    fi
    
    runBenchmark
    cleanUp

    runPlotUsage
}

main