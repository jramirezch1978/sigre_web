# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.sync-service.xml ./pom.xml
COPY sigre-common/pom.xml ./sigre-common/pom.xml
COPY sync-service/pom.xml ./sync-service/pom.xml
COPY sigre-common/src ./sigre-common/src
COPY sync-service/src ./sync-service/src

RUN mvn clean package -Dmaven.test.skip=true -pl sync-service -am

# Etapa de produccion
FROM eclipse-temurin:17-jre-jammy

RUN apt-get update && apt-get install -y tzdata curl && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Lima
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

COPY --from=builder /app/sync-service/target/sync-service-*.jar app.jar

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=8088
ENV SPRING_PROFILES_ACTIVE=docker

EXPOSE 8088

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:8088/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
