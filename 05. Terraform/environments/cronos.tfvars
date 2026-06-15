# ============================================================
# SIGRE ERP — Servidor CRONOS (producción / pruebas)
# ============================================================
# VM: Oracle Linux 9.7 — cronos — 192.168.0.163
# RAM: 10 GB | CPU: 4 vCPU | Disco: 300 GB (/home ~223 GB libres)
# Docker data-root: /home/docker
# Stack infra: /home/jramirez/stack (red stack_default)
# NAT: crisaor.serveftp.com → 8080 frontend, 9080 API GW, 5432 PG
# ============================================================

environment         = "cronos"
deployment_target   = "docker-compose"
project_id          = "sigre-erp"
region              = "us-east1"

generate_docker_compose    = true
docker_compose_output_dir  = "../deploy/cronos"
use_prebuilt_images        = true
image_registry             = "ghcr.io/jramirezch1978/sigre"
image_tag                  = "latest"

# ── Servidor cronos ──────────────────────────────────────────

server_spec = {
  ram_gb    = 10
  cpu_cores = 4
  disk_gb   = 300
  hostname  = "cronos"
  ip_local  = "192.168.0.163"
}

docker_stack = {
  network_name     = "stack_default"
  stack_dir        = "/home/jramirez/stack"
  repo_dir         = "/home/jramirez/sigre_web"
  docker_data_root = "/home/docker"
  docker_context   = "cronos"
  public_host      = "crisaor.serveftp.com"
  public_ip        = "190.117.92.142"
  timezone         = "America/Lima"
  app_user         = "erpsigre"
}

service_ports = {
  frontend    = 8080
  api_gateway = 9080
  postgres    = 5432
  sonarqube   = 9001
  eureka      = 8761
}

# ── Disco (/home) ────────────────────────────────────────────

disk_allocation = {
  postgres  = 80
  sonarqube = 15
  backups   = 50
  logs      = 10
  docker    = 30
  os_swap   = 20
}

# ── PostgreSQL 17 (~3 GB RAM — igual que cronos en producción) ─

postgres_config = {
  container_name = "postgres17"
  service_name   = "postgres"
  image          = "postgres:17"
  superuser      = "postgres"
  databases      = ["sigre_security", "sigre_template"]
  init_scripts   = []
  shm_size       = "256mb"
}

pg_tuning = {
  shared_buffers_mb            = 768
  effective_cache_size_mb      = 2048
  work_mem_mb                  = 16
  maintenance_work_mem_mb      = 128
  wal_buffers_mb               = 16
  max_connections              = 100
  max_parallel_workers         = 2
  max_parallel_workers_gather  = 1
  max_parallel_maintenance     = 1
  random_page_cost             = 1.1
  effective_io_concurrency     = 200
  checkpoint_completion_target = 0.9
  autovacuum_scale_factor      = 0.05
  log_min_duration_ms          = 500
  timezone                     = "America/Lima"
}

postgres_resources = {
  memory_limit   = "3g"
  memory_request = "2g"
  cpu_limit      = "1500m"
  cpu_request    = "500m"
}

# Contraseñas: definir en secrets.tfvars (no commitear)
# db_admin_password = "..."
# erp_app_password  = "..."

# ── SonarQube (perfil tools — bajo demanda, ~3 GB) ───────────

testing_resources = {
  sonarqube = {
    memory_limit   = "3g"
    memory_request = "2g"
    cpu_limit      = "1000m"
    enabled        = true
    image          = "sonarqube:community"
    container_name = "sonarqube"
    restart        = "no"
    host_port      = 9001
    jdbc_username  = "sonarqube"
  }
}

# ── Frontend Angular (~128 MB) ───────────────────────────────

frontend_resources = {
  memory_limit     = "128Mi"
  cpu_limit        = "250m"
  image_name       = "sigre-frontend"
  container_name   = "sigre-frontend"
}

# ── Backend Fase 1 (~1.5 GB total app) ───────────────────────
# discovery-server + api-gateway + asistencia-service

microservice_resources = {

  "discovery-server" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "128m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 8761
    priority       = "critical"
    image_name     = "discovery-server"
    container_name = "discovery-server"
    enabled        = true
    expose_port    = false
    db_name        = "sigre_security"
  }

  "api-gateway" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "192m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9080
    priority       = "critical"
    image_name     = "api-gateway"
    container_name = "api-gateway"
    enabled        = true
    expose_port    = true
    db_name        = "sigre_security"
  }

  "asistencia-service" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "192m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 8084
    priority       = "high"
    image_name     = "asistencia-service"
    container_name = "asistencia-service"
    enabled        = true
    expose_port    = false
    db_name        = "sigre_emp_cantabria"
  }
}

# GCP desactivado en cronos
gke_node_count = 0
gke_min_nodes  = 0
gke_max_nodes  = 0
