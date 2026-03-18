# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar el pom.xml padre
COPY pom.xml ./pom.xml

# Copiar pom.xml de todos los modulos para resolver dependencias
COPY discovery-server/pom.xml ./discovery-server/pom.xml
COPY config-server/pom.xml ./config-server/pom.xml
COPY api-gateway/pom.xml ./api-gateway/pom.xml
COPY asistencia-service/pom.xml ./asistencia-service/pom.xml
COPY inventory-service/pom.xml ./inventory-service/pom.xml
COPY orders-service/pom.xml ./orders-service/pom.xml
COPY products-service/pom.xml ./products-service/pom.xml
COPY sync-service/pom.xml ./sync-service/pom.xml
COPY sigre-config-common/pom.xml ./sigre-config-common/pom.xml
COPY sigre-config-common/src ./sigre-config-common/src

# Copiar el codigo fuente del comedor-service
COPY comedor-service/pom.xml ./comedor-service/pom.xml
COPY comedor-service/src ./comedor-service/src

# Construir solo el comedor-service
RUN mvn clean package -DskipTests -pl comedor-service -am

# Etapa de produccion
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
COPY --from=builder /app/comedor-service/target/*.jar app.jar

# Crear usuario no root
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=8092
ENV EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://localhost:8761/eureka/
ENV TZ=America/Lima

# Exponer puerto
EXPOSE 8092

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8092/actuator/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]