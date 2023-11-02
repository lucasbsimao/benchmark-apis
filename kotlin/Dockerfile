FROM openjdk:17-jdk-alpine3.14

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN ./gradlew build

CMD java -Xms128m -Xmx512m -jar app/build/libs/app.jar