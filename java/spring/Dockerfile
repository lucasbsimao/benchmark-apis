FROM openjdk:17-jdk-alpine3.14

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN ./gradlew build

CMD java -jar app/build/libs/app.jar