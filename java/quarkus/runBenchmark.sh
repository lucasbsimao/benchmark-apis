#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk use java 17.0.8-zulu

./gradlew build
java -jar build/quarkus-app/quarkus-run.jar > /dev/null 2>&1 &

echo $!