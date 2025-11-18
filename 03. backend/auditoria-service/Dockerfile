FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/auditoria-service-*.jar app.jar
EXPOSE 8097
ENTRYPOINT ["java", "-jar", "app.jar"]

