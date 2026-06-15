# Etapa de construcción
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.ms-auth-security.xml ./pom.xml
COPY sigre-common/pom.xml ./sigre-common/pom.xml
COPY ms-auth-security/pom.xml ./ms-auth-security/pom.xml
COPY sigre-common/src ./sigre-common/src
COPY ms-auth-security/src ./ms-auth-security/src

RUN mvn clean package -DskipTests -pl ms-auth-security -am

# Etapa de producción
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    tzdata \
    && ln -fs /usr/share/zoneinfo/America/Lima /etc/localtime \
    && echo "America/Lima" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/ms-auth-security/target/ms-auth-security-*.jar app.jar

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=9001
ENV TZ=America/Lima

EXPOSE 9001

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:9001/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
