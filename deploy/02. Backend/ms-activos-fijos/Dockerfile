# Etapa 1: compilaciÃ³n (Maven + JDK). No forma parte de la imagen final.
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY . .
RUN mvn -pl ms-activos-fijos -am clean package -DskipTests

# Etapa 2: solo JRE + JAR (imagen final compacta).
FROM eclipse-temurin:21-jre-alpine AS runtime
LABEL maintainer="Restaurant.pe Team"

RUN apk add --no-cache tzdata
ENV TZ=America/Lima

WORKDIR /app
COPY --from=build /workspace/ms-activos-fijos/target/ms-activos-fijos-*.jar app.jar
EXPOSE 9008
# Heap acotado respecto al límite de memoria del pod (K8s); el JVM usa cgroups vía UseContainerSupport (por defecto en JDK 21).
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=70.0"
ENTRYPOINT ["java", "-Duser.timezone=America/Lima", "-jar", "app.jar"]
