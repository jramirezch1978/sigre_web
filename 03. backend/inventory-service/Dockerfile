# Etapa de construcción
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar el pom.xml del proyecto padre
COPY ../pom.xml ./pom.xml

# Copiar el pom.xml del microservicio
COPY pom.xml ./inventory-service/pom.xml

# Copiar el código fuente
COPY src ./inventory-service/src

# Cambiar al directorio del microservicio
WORKDIR /app/inventory-service

# Construir la aplicación
RUN mvn clean package -DskipTests

# Etapa de producción
FROM openjdk:17-jdk-slim

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
COPY --from=builder /app/inventory-service/target/*.jar app.jar

# Crear usuario no root
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Configurar variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV TZ=America/Lima

# Exponer puerto
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
