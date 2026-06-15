# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.almacen-service.xml ./pom.xml
COPY sigre-common/pom.xml ./sigre-common/pom.xml
COPY almacen-service/pom.xml ./almacen-service/pom.xml
COPY sigre-common/src ./sigre-common/src
COPY almacen-service/src ./almacen-service/src

RUN mvn clean package -DskipTests -pl almacen-service -am

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

COPY --from=builder /app/almacen-service/target/almacen-service-*.jar app.jar

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=9003
ENV TZ=America/Lima

EXPOSE 9003

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:9003/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
