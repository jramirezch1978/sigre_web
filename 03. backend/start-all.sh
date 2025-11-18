#!/bin/bash

# Script para iniciar todos los microservicios en orden
# Uso: ./start-all.sh

echo "======================================"
echo "  SIGRE 2.0 - Inicio de Servicios"
echo "======================================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para esperar que un servicio esté listo
wait_for_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=0
    
    echo -e "${YELLOW}Esperando que ${service_name} esté listo en puerto ${port}...${NC}"
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:${port}/actuator/health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ ${service_name} está listo${NC}"
            return 0
        fi
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}✗ ${service_name} no respondió a tiempo${NC}"
    return 1
}

# Fase 1: Service Discovery
echo -e "${YELLOW}[Fase 1] Iniciando Service Discovery...${NC}"
cd service-discovery
mvn spring-boot:run > ../logs/service-discovery.log 2>&1 &
echo $! > ../pids/service-discovery.pid
cd ..
wait_for_service "Service Discovery" 8761
echo ""

# Fase 2: Config Server
echo -e "${YELLOW}[Fase 2] Iniciando Config Server...${NC}"
cd config-server
mvn spring-boot:run > ../logs/config-server.log 2>&1 &
echo $! > ../pids/config-server.pid
cd ..
wait_for_service "Config Server" 8888
echo ""

# Fase 3: API Gateway
echo -e "${YELLOW}[Fase 3] Iniciando API Gateway...${NC}"
cd api-gateway
mvn spring-boot:run > ../logs/api-gateway.log 2>&1 &
echo $! > ../pids/api-gateway.pid
cd ..
wait_for_service "API Gateway" 8080
echo ""

# Fase 4: Servicio Core (Seguridad)
echo -e "${YELLOW}[Fase 4] Iniciando Servicio Core...${NC}"

cd seguridad-service
mvn spring-boot:run > ../logs/seguridad-service.log 2>&1 &
echo $! > ../pids/seguridad-service.pid
cd ..

sleep 10
echo ""

# Fase 5: Servicios de Negocio (en paralelo)
echo -e "${YELLOW}[Fase 5] Iniciando Servicios de Negocio...${NC}"

services=(
    "contabilidad-service:8082"
    "finanzas-service:8083"
    "almacen-service:8084"
    "rrhh-service:8085"
    "produccion-service:8086"
    "flota-service:8087"
    "comercializacion-service:8088"
    "compras-service:8089"
)

for service_port in "${services[@]}"; do
    IFS=':' read -r service port <<< "$service_port"
    if [ -d "$service" ]; then
        echo "Iniciando ${service}..."
        cd $service
        mvn spring-boot:run > ../logs/${service}.log 2>&1 &
        echo $! > ../pids/${service}.pid
        cd ..
    fi
done

echo ""
echo -e "${GREEN}======================================"
echo "  Todos los servicios iniciados"
echo "======================================${NC}"
echo ""
echo "URLs de acceso:"
echo "  - Eureka Dashboard: http://localhost:8761"
echo "  - API Gateway: http://localhost:8080"
echo "  - Swagger Contabilidad: http://localhost:8082/swagger-ui.html"
echo ""
echo "Para ver logs: tail -f logs/<servicio>.log"
echo "Para detener: ./stop-all.sh"

