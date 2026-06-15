$ErrorActionPreference = 'Stop'
$backend = 'e:\Work\sigre_web\03. backend'
$services = @(
    @{ Name = 'contabilidad-service'; Port = 9006 },
    @{ Name = 'finanzas-service'; Port = 9005 },
    @{ Name = 'produccion-service'; Port = 9009 },
    @{ Name = 'rrhh-service'; Port = 9007 },
    @{ Name = 'comercializacion-service'; Port = 9010 }
)

$template = Get-Content (Join-Path $backend 'docker\pom.compras-service.xml') -Raw
foreach ($s in $services) {
    $content = $template -replace 'compras-service', $s.Name
    Set-Content -Path (Join-Path $backend "docker\pom.$($s.Name).xml") -Value $content -Encoding UTF8

    $docker = @"
# Etapa de construccion
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY docker/pom.$($s.Name).xml ./pom.xml
COPY sigre-common/pom.xml ./sigre-common/pom.xml
COPY $($s.Name)/pom.xml ./$($s.Name)/pom.xml
COPY sigre-common/src ./sigre-common/src
COPY $($s.Name)/src ./$($s.Name)/src

RUN mvn clean package -Dmaven.test.skip=true -pl $($s.Name) -am

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

COPY --from=builder /app/$($s.Name)/target/$($s.Name)-*.jar app.jar

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

ENV JAVA_OPTS="-Xmx512m -Xms256m -Duser.timezone=America/Lima"
ENV SERVER_PORT=$($s.Port)
ENV TZ=America/Lima

EXPOSE $($s.Port)

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:$($s.Port)/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java `$JAVA_OPTS -jar app.jar"]
"@
    Set-Content -Path (Join-Path $backend "$($s.Name)\Dockerfile") -Value $docker -Encoding UTF8
}

$dockerProfile = @'

---
spring:
  config:
    activate:
      on-profile: docker

eureka:
  client:
    service-url:
      defaultZone: http://discovery-server:8761/eureka
  instance:
    prefer-ip-address: true
'@

foreach ($s in $services) {
    $yml = Join-Path $backend "$($s.Name)\src\main\resources\application.yml"
    if (Test-Path $yml) {
        $text = Get-Content $yml -Raw
        if ($text -notmatch 'on-profile: docker') {
            $text = $text -replace '\$\{DB_HOST:localhost\}', '${DB_HOST:postgres}'
            $text = $text + $dockerProfile
            Set-Content -Path $yml -Value $text -Encoding UTF8 -NoNewline
        }
    }
}

Write-Host 'Docker y application.yml OK'
