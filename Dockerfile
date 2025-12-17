FROM openjdk:17-jdk-bullseye
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]