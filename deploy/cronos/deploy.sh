# SIGRE ERP — Despliegue cronos (desde la VM o vía SSH)

set -euo pipefail

ACTION="${1:-all}"
STACK_DIR="/home/jramirez/stack"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== SIGRE deploy cronos — acción: ${ACTION} ==="

copy_files() {
  mkdir -p "${STACK_DIR}/init"
  cp "${SCRIPT_DIR}/docker-compose.stack.yml" "${STACK_DIR}/"
  cp "${SCRIPT_DIR}/docker-compose.app.yml" "${STACK_DIR}/"
  cp "${SCRIPT_DIR}/init/01-create-databases.sql" "${STACK_DIR}/init/"
  if [[ ! -f "${STACK_DIR}/.env" ]]; then
    cp "${SCRIPT_DIR}/.env.example" "${STACK_DIR}/.env"
    echo "Configure ${STACK_DIR}/.env antes de levantar la app."
  fi
}

case "${ACTION}" in
  stack)
    copy_files
    docker compose -f "${STACK_DIR}/docker-compose.stack.yml" pull
    docker compose -f "${STACK_DIR}/docker-compose.stack.yml" up -d
    ;;
  app)
    copy_files
    docker compose --env-file "${STACK_DIR}/.env" -f "${STACK_DIR}/docker-compose.app.yml" pull
    docker compose --env-file "${STACK_DIR}/.env" -f "${STACK_DIR}/docker-compose.app.yml" up -d
    ;;
  all)
    "$0" stack
    "$0" app
    ;;
  sonarqube-up)
    docker compose --profile tools -f "${STACK_DIR}/docker-compose.stack.yml" up -d sonarqube
    ;;
  sonarqube-down)
    docker compose --profile tools -f "${STACK_DIR}/docker-compose.stack.yml" stop sonarqube
    ;;
  status)
    docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    echo ""
    echo "Frontend:  http://crisaor.serveftp.com:8080"
    echo "API GW:    http://crisaor.serveftp.com:9080/actuator/health"
    echo "SonarQube: http://crisaor.serveftp.com:9000"
    ;;
  *)
    echo "Uso: $0 [stack|app|all|sonarqube-up|sonarqube-down|status]"
    exit 1
    ;;
esac
