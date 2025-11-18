FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/comedor-service-*.jar app.jar
EXPOSE 8092
ENTRYPOINT ["java", "-jar", "app.jar"]

