#!/bin/bash

# Script para verificar el estado de todos los servicios
# Uso: ./health-check.sh

echo "======================================"
echo "  SIGRE 2.0 - Estado de Servicios"
echo "======================================"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para verificar un servicio
check_service() {
    local service_name=$1
    local port=$2
    
    printf "%-30s" "$service_name"
    
    if curl -s http://localhost:${port}/actuator/health > /dev/null 2>&1; then
        response=$(curl -s http://localhost:${port}/actuator/health | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        if [ "$response" == "UP" ]; then
            echo -e "${GREEN}✓ UP${NC} (puerto ${port})"
        else
            echo -e "${YELLOW}⚠ ${response}${NC} (puerto ${port})"
        fi
    else
        echo -e "${RED}✗ DOWN${NC} (puerto ${port})"
    fi
}

# Infraestructura
echo "INFRAESTRUCTURA:"
check_service "Service Discovery" 8761
check_service "Config Server" 8888
check_service "API Gateway" 8080
echo ""

# Core
echo "SERVICIO CORE:"
check_service "Seguridad" 8081
echo ""

# Negocio
echo "SERVICIOS DE NEGOCIO:"
check_service "Contabilidad" 8082
check_service "Finanzas" 8083
check_service "Almacén" 8084
check_service "RRHH" 8085
check_service "Producción" 8086
check_service "Flota" 8087
check_service "Comercialización" 8088
check_service "Compras" 8089
check_service "Aprovisionamiento" 8090
check_service "Asistencia" 8091
check_service "Comedor" 8092
check_service "Mantenimiento" 8093
check_service "Operaciones" 8094
check_service "Campo" 8095
check_service "Activo Fijo" 8096
check_service "Auditoría" 8097
check_service "SIG" 8098
check_service "Presupuesto" 8099
echo ""

# Infraestructura Externa
echo "INFRAESTRUCTURA EXTERNA:"
printf "%-30s" "Oracle Database"
if nc -z localhost 1521 2>/dev/null; then
    echo -e "${GREEN}✓ UP${NC} (puerto 1521)"
else
    echo -e "${RED}✗ DOWN${NC} (puerto 1521)"
fi

printf "%-30s" "Redis"
if redis-cli ping > /dev/null 2>&1; then
    echo -e "${GREEN}✓ UP${NC} (puerto 6379)"
else
    echo -e "${RED}✗ DOWN${NC} (puerto 6379)"
fi

printf "%-30s" "RabbitMQ"
if curl -s http://localhost:15672 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ UP${NC} (puerto 5672/15672)"
else
    echo -e "${RED}✗ DOWN${NC} (puerto 5672/15672)"
fi

printf "%-30s" "MongoDB"
if nc -z localhost 27017 2>/dev/null; then
    echo -e "${GREEN}✓ UP${NC} (puerto 27017)"
else
    echo -e "${RED}✗ DOWN${NC} (puerto 27017)"
fi

echo ""
echo "======================================"

