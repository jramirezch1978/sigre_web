# Etapa de construcción
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.asistencia-service.xml ./pom.xml
COPY sigre-config-common/pom.xml ./sigre-config-common/pom.xml
COPY asistencia-service/pom.xml ./asistencia-service/pom.xml
COPY sigre-config-common/src ./sigre-config-common/src
COPY asistencia-service/src ./asistencia-service/src

RUN mvn clean package -DskipTests -pl asistencia-service -am

# Etapa de producción
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Configurar zona horaria de Lima
RUN apt-get update && apt-get install -y \
    curl \
    netcat-traditional \
    tzdata \
    && ln -fs /usr/share/zoneinfo/America/Lima /etc/localtime \
    && echo "America/Lima" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copiar el JAR construido
COPY --from=builder /app/asistencia-service/target/*.jar app.jar

# Crear usuario no root
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Configurar variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=8084
ENV EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://localhost:8761/eureka/
ENV TZ=America/Lima

# Exponer puerto
EXPOSE 8084

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8084/api/time/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
