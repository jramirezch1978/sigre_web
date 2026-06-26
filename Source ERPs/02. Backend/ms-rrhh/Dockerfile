# Etapa 1: compilacion (Maven + JDK). No forma parte de la imagen final.
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY . .
# Eliminar del pom.xml padre los modulos no presentes en el contexto de build.
# Necesario cuando el contexto solo incluye common/ + ms-rrhh/ (build local).
RUN for mod in $(sed -n 's|.*<module>\(.*\)</module>.*|\1|p' pom.xml); do \
      [ ! -d "$mod" ] && sed -i "s|<module>${mod}</module>||g" pom.xml; \
    done
RUN mvn -pl ms-rrhh -am clean package -DskipTests

# Etapa 2: solo JRE + JAR (imagen final compacta).
FROM eclipse-temurin:21-jre-alpine AS runtime
LABEL maintainer="Restaurant.pe Team"

RUN apk add --no-cache tzdata
ENV TZ=America/Lima

WORKDIR /app
COPY --from=build /workspace/ms-rrhh/target/ms-rrhh-*.jar app.jar
EXPOSE 9007
ENTRYPOINT ["java", "-Duser.timezone=America/Lima", "-jar", "app.jar"]
