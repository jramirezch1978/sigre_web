#!/bin/bash

# Script para detener todos los microservicios
# Uso: ./stop-all.sh

echo "======================================"
echo "  SIGRE 2.0 - Detener Servicios"
echo "======================================"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Crear directorio de PIDs si no existe
mkdir -p pids

# Función para detener un servicio
stop_service() {
    local service_name=$1
    local pid_file="pids/${service_name}.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo "Deteniendo ${service_name} (PID: ${pid})..."
            kill $pid
            sleep 2
            if ps -p $pid > /dev/null 2>&1; then
                echo -e "${RED}Forzando cierre de ${service_name}${NC}"
                kill -9 $pid
            fi
            rm "$pid_file"
            echo -e "${GREEN}✓ ${service_name} detenido${NC}"
        else
            echo "${service_name} no está ejecutándose"
            rm "$pid_file"
        fi
    else
        echo "${service_name}: no se encontró archivo PID"
    fi
}

# Detener servicios en orden inverso
services=(
    "presupuesto-service"
    "sig-service"
    "auditoria-service"
    "activo-fijo-service"
    "campo-service"
    "operaciones-service"
    "mantenimiento-service"
    "comedor-service"
    "asistencia-service"
    "aprovision-service"
    "compras-service"
    "comercializacion-service"
    "flota-service"
    "produccion-service"
    "rrhh-service"
    "almacen-service"
    "finanzas-service"
    "contabilidad-service"
    "seguridad-service"
    "api-gateway"
    "config-server"
    "service-discovery"
)

for service in "${services[@]}"; do
    stop_service "$service"
done

echo ""
echo -e "${GREEN}Todos los servicios han sido detenidos${NC}"

