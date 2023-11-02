FROM openjdk:17-jdk-alpine3.14

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN ./gradlew build

CMD java -Xms128m -Xmx512m -jar build/libs/app-0.1-all-optimized.jar