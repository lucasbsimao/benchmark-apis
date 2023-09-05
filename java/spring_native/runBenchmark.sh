#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk use java 17.0.8-graalce

./gradlew nativeCompile
cd app/build/native/nativeCompile
./app > /dev/null 2>&1 &

echo $!