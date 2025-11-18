FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/operaciones-service-*.jar app.jar
EXPOSE 8094
ENTRYPOINT ["java", "-jar", "app.jar"]

