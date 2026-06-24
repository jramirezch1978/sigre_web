# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.rrhh-service.xml ./pom.xml
COPY sigre-common/pom.xml ./sigre-common/pom.xml
COPY rrhh-service/pom.xml ./rrhh-service/pom.xml
COPY sigre-common/src ./sigre-common/src
COPY rrhh-service/src ./rrhh-service/src

RUN mvn clean package -DskipTests -pl rrhh-service -am

# Etapa de produccion
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    tzdata \
    && ln -fs /usr/share/zoneinfo/America/Lima /etc/localtime \
    && echo "America/Lima" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/rrhh-service/target/rrhh-service-*.jar app.jar

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=9007
ENV TZ=America/Lima

EXPOSE 9007

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:9007/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
