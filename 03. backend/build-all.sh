#!/bin/bash

# Script para compilar todos los microservicios SIGRE 2.0
# Uso: ./build-all.sh

echo "======================================"
echo "  SIGRE 2.0 - Compilación Completa"
echo "======================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para compilar un módulo
build_module() {
    local module=$1
    echo -e "${YELLOW}Compilando: ${module}${NC}"
    cd $module
    mvn clean install -DskipTests
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ ${module} compilado exitosamente${NC}"
        cd ..
        return 0
    else
        echo -e "${RED}✗ Error compilando ${module}${NC}"
        cd ..
        return 1
    fi
}

# Compilar parent POM primero
echo -e "${YELLOW}Compilando Parent POM...${NC}"
mvn clean install -N
if [ $? -ne 0 ]; then
    echo -e "${RED}Error compilando Parent POM. Abortando.${NC}"
    exit 1
fi
echo ""

# Array de módulos en orden de dependencia
modules=(
    # Infraestructura
    "service-discovery"
    "config-server"
    "api-gateway"
    
    # Core
    "seguridad-service"
    
    # Financiero-Contable
    "contabilidad-service"
    "finanzas-service"
    
    # Operativo
    "almacen-service"
    "rrhh-service"
    "produccion-service"
    "flota-service"
    
    # Comercial
    "comercializacion-service"
    "compras-service"
    "aprovision-service"
    
    # Soporte
    "asistencia-service"
    "comedor-service"
    "mantenimiento-service"
    "operaciones-service"
    "campo-service"
    "activo-fijo-service"
    "auditoria-service"
    "sig-service"
    "presupuesto-service"
)

# Contador de éxitos y fallos
success_count=0
fail_count=0
failed_modules=()

# Compilar cada módulo
for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        build_module "$module"
        if [ $? -eq 0 ]; then
            ((success_count++))
        else
            ((fail_count++))
            failed_modules+=("$module")
        fi
        echo ""
    else
        echo -e "${YELLOW}⚠ Módulo ${module} no encontrado, saltando...${NC}"
        echo ""
    fi
done

# Resumen
echo "======================================"
echo "  RESUMEN DE COMPILACIÓN"
echo "======================================"
echo -e "${GREEN}Exitosos: ${success_count}${NC}"
if [ $fail_count -gt 0 ]; then
    echo -e "${RED}Fallidos: ${fail_count}${NC}"
    echo ""
    echo "Módulos fallidos:"
    for module in "${failed_modules[@]}"; do
        echo -e "  ${RED}- ${module}${NC}"
    done
    exit 1
else
    echo -e "${GREEN}¡Todos los módulos compilados exitosamente!${NC}"
    exit 0
fi

