FROM ghcr.io/graalvm/graalvm-ce:ol7-java17-22.3.3

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN ./gradlew nativeCompile


CMD cd app/build/native/nativeCompile && ./app