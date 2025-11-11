# Etapa de construcción
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar el pom.xml padre primero
COPY pom.xml ./pom.xml

# Copiar todos los pom.xml de los módulos para resolver dependencias
COPY discovery-server/pom.xml ./discovery-server/pom.xml
COPY config-server/pom.xml ./config-server/pom.xml
COPY api-gateway/pom.xml ./api-gateway/pom.xml
COPY asistencia-service/pom.xml ./asistencia-service/pom.xml
COPY inventory-service/pom.xml ./inventory-service/pom.xml
COPY orders-service/pom.xml ./orders-service/pom.xml
COPY products-service/pom.xml ./products-service/pom.xml
COPY sync-service/pom.xml ./sync-service/pom.xml

# Copiar el código fuente del api-gateway
COPY api-gateway/src ./api-gateway/src

# Construir directamente sin dependency:go-offline (MÁS RÁPIDO)
RUN mvn clean package -DskipTests -pl api-gateway -am

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
COPY --from=builder /app/api-gateway/target/*.jar app.jar

# Crear usuario no root
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Configurar variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV TZ=America/Lima

# Exponer puerto
EXPOSE 9080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:9080/actuator/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]