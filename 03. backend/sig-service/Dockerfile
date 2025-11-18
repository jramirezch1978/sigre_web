FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/sig-service-*.jar app.jar
EXPOSE 8098
ENTRYPOINT ["java", "-jar", "app.jar"]

