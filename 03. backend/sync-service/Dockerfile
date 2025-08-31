# Etapa de construcción
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar POM padre
COPY pom.xml ./
COPY sync-service/pom.xml ./sync-service/

# Copiar código fuente del sync-service
COPY sync-service/src ./sync-service/src

# Compilar solo el sync-service
RUN mvn clean package -DskipTests -pl sync-service -am

# Etapa de ejecución
FROM openjdk:17-jdk-slim

# Instalar tzdata para timezone y curl para health checks
RUN apt-get update && apt-get install -y tzdata curl && rm -rf /var/lib/apt/lists/*

# Configurar timezone
ENV TZ=America/Lima
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# Copiar JAR compilado
COPY --from=builder /app/sync-service/target/*.jar app.jar

# Exponer puerto
EXPOSE 8088

# Variables de entorno
ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"

# Comando de ejecución
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
