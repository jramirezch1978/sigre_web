#!/bin/bash
# ============================================================
# Restaurant.pe ERP — Terraform Container Entrypoint
# ============================================================

set -euo pipefail

# ── Colores ──────────────────────────────────────────────────
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
CYAN='\033[0;96m'
BOLD='\033[1m'
DIM='\033[0;90m'
RESET='\033[0m'

# ── Banner ───────────────────────────────────────────────────
show_banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  ╔══════════════════════════════════════════════════╗"
  echo "  ║     SIGRE ERP — Terraform Runner                 ║"
  echo "  ╚══════════════════════════════════════════════════╝"
  echo -e "${RESET}"
  echo -e "  ${DIM}Terraform $(terraform version -json 2>/dev/null | jq -r '.terraform_version' 2>/dev/null || terraform version | head -1)${RESET}"
  echo -e "  ${DIM}Workspace: /workspace${RESET}"
  echo ""
}

# ── Configurar credenciales GCP si existen ───────────────────
setup_gcp_credentials() {
  if [ -f "/credentials/gcp-key.json" ]; then
    export GOOGLE_APPLICATION_CREDENTIALS="/credentials/gcp-key.json"
    echo -e "${GREEN}[OK]${RESET} Credenciales GCP cargadas desde /credentials/gcp-key.json"
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS" --quiet 2>/dev/null || true
  elif [ -n "${GOOGLE_APPLICATION_CREDENTIALS:-}" ]; then
    echo -e "${GREEN}[OK]${RESET} Usando GOOGLE_APPLICATION_CREDENTIALS del entorno"
  else
    echo -e "${YELLOW}[WARN]${RESET} Sin credenciales GCP. Monte /credentials/gcp-key.json o defina GOOGLE_APPLICATION_CREDENTIALS"
  fi
}

# ── Crear cache de plugins ───────────────────────────────────
setup_plugin_cache() {
  mkdir -p "${TF_PLUGIN_CACHE_DIR:-/workspace/.terraform-plugin-cache}"
}

# ── Ayuda ────────────────────────────────────────────────────
show_help() {
  echo -e "${BOLD}USO:${RESET}"
  echo ""
  echo -e "  Desde docker-compose:"
  echo -e "    ${GREEN}docker-compose exec terraform init${RESET}"
  echo -e "    ${GREEN}docker-compose exec terraform plan dev${RESET}"
  echo -e "    ${GREEN}docker-compose exec terraform apply dev${RESET}"
  echo -e "    ${GREEN}docker-compose exec terraform destroy dev${RESET}"
  echo ""
  echo -e "  Comandos de atajo:"
  echo -e "    ${CYAN}init${RESET}              terraform init"
  echo -e "    ${CYAN}plan <env>${RESET}        terraform plan -var-file=environments/<env>.tfvars"
  echo -e "    ${CYAN}apply <env>${RESET}       terraform apply -var-file=environments/<env>.tfvars"
  echo -e "    ${CYAN}destroy <env>${RESET}     terraform destroy -var-file=environments/<env>.tfvars"
  echo -e "    ${CYAN}output${RESET}            terraform output"
  echo -e "    ${CYAN}validate${RESET}          terraform validate"
  echo -e "    ${CYAN}fmt${RESET}               terraform fmt -recursive"
  echo -e "    ${CYAN}shell${RESET}             Abrir bash interactivo"
  echo -e "    ${CYAN}help${RESET}              Mostrar esta ayuda"
  echo ""
  echo -e "  Ambientes disponibles: ${BOLD}cronos${RESET}, ${BOLD}dev${RESET}, ${BOLD}staging${RESET}, ${BOLD}prod${RESET}"
  echo ""
  echo -e "  Terraform directo:"
  echo -e "    ${GREEN}docker-compose exec terraform terraform state list${RESET}"
  echo -e "    ${GREEN}docker-compose exec terraform terraform import ...${RESET}"
  echo ""
}

# ── Validar ambiente ─────────────────────────────────────────
validate_env() {
  local env="${1:-}"
  if [ -z "$env" ]; then
    echo -e "${RED}[ERROR]${RESET} Debe especificar un ambiente: dev, staging o prod"
    echo -e "  Ejemplo: ${GREEN}plan dev${RESET}"
    exit 1
  fi
  if [ ! -f "environments/${env}.tfvars" ]; then
    echo -e "${RED}[ERROR]${RESET} Archivo environments/${env}.tfvars no encontrado"
    echo -e "  Ambientes disponibles:"
    ls -1 environments/*.tfvars 2>/dev/null | sed 's|environments/||;s|\.tfvars||;s|^|    |' || echo "    (ninguno)"
    exit 1
  fi
}

# ── Main ─────────────────────────────────────────────────────

show_banner
setup_gcp_credentials
setup_plugin_cache

COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
  init)
    echo -e "${YELLOW}[TF]${RESET} terraform init $*"
    terraform init "$@"
    ;;

  plan)
    ENV="${1:-}"
    validate_env "$ENV"
    shift || true
    echo -e "${YELLOW}[TF]${RESET} terraform plan -var-file=environments/${ENV}.tfvars $*"
    terraform plan -var-file="environments/${ENV}.tfvars" "$@"
    ;;

  apply)
    ENV="${1:-}"
    validate_env "$ENV"
    shift || true
    echo -e "${YELLOW}[TF]${RESET} terraform apply -var-file=environments/${ENV}.tfvars $*"
    terraform apply -var-file="environments/${ENV}.tfvars" -auto-approve "$@"
    ;;

  destroy)
    ENV="${1:-}"
    validate_env "$ENV"
    shift || true
    echo -e "${RED}[TF]${RESET} terraform destroy -var-file=environments/${ENV}.tfvars $*"
    echo -e "${RED}${BOLD}¡CUIDADO! Esto destruirá toda la infraestructura del ambiente ${ENV}.${RESET}"
    terraform destroy -var-file="environments/${ENV}.tfvars" "$@"
    ;;

  output)
    terraform output "$@"
    ;;

  validate)
    echo -e "${YELLOW}[TF]${RESET} terraform validate"
    terraform validate "$@"
    ;;

  fmt)
    echo -e "${YELLOW}[TF]${RESET} terraform fmt -recursive"
    terraform fmt -recursive "$@"
    ;;

  shell)
    echo -e "${GREEN}[SHELL]${RESET} Abriendo bash interactivo..."
    exec /bin/bash
    ;;

  help|--help|-h)
    show_help
    ;;

  # Cualquier otro comando se pasa directo a terraform
  terraform)
    terraform "$@"
    ;;

  *)
    # Si no es un atajo conocido, intentar como comando terraform directo
    terraform "$COMMAND" "$@"
    ;;
esac
