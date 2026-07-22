# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.worker-service.xml ./pom.xml
COPY worker-service/pom.xml ./worker-service/pom.xml
COPY worker-service/src ./worker-service/src

RUN mvn clean package -DskipTests -pl worker-service -am

# Etapa de produccion
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copiar el JAR ANTES de apt-get: con DOCKER_BUILDKIT=0 (legacy) el stage
# builder puede desaparecer si apt tarda mucho (red lenta / security.ubuntu.com).
COPY --from=builder /app/worker-service/target/worker-service-*.jar app.jar

RUN apt-get update && apt-get install -y \
    curl \
    tzdata \
    && ln -fs /usr/share/zoneinfo/America/Lima /etc/localtime \
    && echo "America/Lima" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx256m -Xms128m -Duser.timezone=America/Lima"
ENV SERVER_PORT=9050
ENV TZ=America/Lima

EXPOSE 9050

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:9050/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
