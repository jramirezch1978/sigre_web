# Etapa 1: compilaciÃ³n (Maven + JDK). No forma parte de la imagen final.
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY . .
RUN mvn -pl eureka-server -am clean package -DskipTests

# Etapa 2: solo JRE + JAR (imagen final compacta).
FROM eclipse-temurin:21-jre-alpine AS runtime
LABEL maintainer="Restaurant.pe Team"

RUN apk add --no-cache tzdata
ENV TZ=America/Lima

WORKDIR /app
COPY --from=build /workspace/eureka-server/target/eureka-server-*.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java", "-Duser.timezone=America/Lima", "-jar", "app.jar"]
