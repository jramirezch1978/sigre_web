# ============================================================
# Restaurant.pe ERP — Ambiente de STAGING
# ============================================================
# Infraestructura: GKE (3 nodos e2-standard-4)
# Cada nodo: 4 vCPU, 16 GB RAM → Total: 12 vCPU, 48 GB RAM
# Cloud SQL: 2 vCPU, 8 GB RAM, 100 GB SSD
# ============================================================

project_id  = "restaurant-pe-staging"
region      = "us-east1"
environment = "staging"

# ── Servidor (referencia para GKE node pool) ─────────────────

server_spec = {
  ram_gb    = 48   # 3 nodos × 16 GB
  cpu_cores = 12   # 3 nodos × 4 vCPU
  disk_gb   = 300  # Cloud SQL + PV claims
}

# ── Distribución de disco ────────────────────────────────────

disk_allocation = {
  postgres      = 100
  elasticsearch = 30
  prometheus    = 15
  rabbitmq      = 10
  redis         = 2
  grafana       = 5
  backups       = 50
  logs          = 30
  docker        = 30
  os_swap       = 20
}

# ── Database ─────────────────────────────────────────────────

db_tier      = "db-custom-2-8192"
db_disk_size = 100

# ── PostgreSQL Tuning (Cloud SQL 2 vCPU / 8 GB) ─────────────

pg_tuning = {
  shared_buffers_mb            = 2048
  effective_cache_size_mb      = 6144
  work_mem_mb                  = 32
  maintenance_work_mem_mb      = 512
  wal_buffers_mb               = 64
  max_connections              = 200
  max_parallel_workers         = 2
  max_parallel_workers_gather  = 1
  max_parallel_maintenance     = 1
  random_page_cost             = 1.1
  effective_io_concurrency     = 200
  checkpoint_completion_target = 0.9
  autovacuum_scale_factor      = 0.05
  log_min_duration_ms          = 300
  timezone                     = "America/Lima"
}

postgres_resources = {
  memory_limit   = "8192Mi"
  memory_request = "4096Mi"
  cpu_limit      = "2000m"
  cpu_request    = "1000m"
}

# ── GKE ──────────────────────────────────────────────────────

gke_node_count   = 3
gke_machine_type = "e2-standard-4"
gke_min_nodes    = 2
gke_max_nodes    = 5
gke_disk_size_gb = 80

# ── RabbitMQ ─────────────────────────────────────────────────

rabbitmq_resources = {
  memory_limit   = "1024Mi"
  memory_request = "512Mi"
  cpu_limit      = "500m"
  cpu_request    = "250m"
  replicas       = 1
}

# ── Redis ────────────────────────────────────────────────────

redis_resources = {
  memory_gb    = 2
  maxmemory_mb = 1536
}

# ── Observabilidad ───────────────────────────────────────────

observability_resources = {
  elasticsearch = {
    memory_limit   = "2048Mi"
    memory_request = "1024Mi"
    cpu_limit      = "1000m"
    heap_mb        = 1024
    replicas       = 1
  }
  kibana = {
    memory_limit = "512Mi"
  }
  prometheus = {
    memory_limit   = "512Mi"
    retention_days = 30
  }
  grafana = {
    memory_limit = "384Mi"
  }
  zipkin = {
    memory_limit = "384Mi"
    jvm_xms      = "128m"
    jvm_xmx      = "256m"
  }
}

# ── Microservicios ───────────────────────────────────────────

microservice_resources = {

  "eureka-server" = {
    memory_limit = "384Mi", memory_request = "256Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "192m", jvm_xmx = "320m"
    replicas = 2, port = 8761, priority = "critical"
  }

  "config-server" = {
    memory_limit = "384Mi", memory_request = "256Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "192m", jvm_xmx = "320m"
    replicas = 2, port = 8888, priority = "critical"
  }

  "api-gateway" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 2, port = 8080, priority = "critical"
  }

  "ms-auth-security" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9001, priority = "critical"
  }

  "ms-core-maestros" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9002, priority = "high"
  }

  "ms-ventas" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9010, priority = "high"
  }

  "ms-contabilidad" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9006, priority = "high"
  }

  "ms-almacen" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9003, priority = "medium"
  }

  "ms-compras" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9004, priority = "medium"
  }

  "ms-finanzas" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9005, priority = "medium"
  }

  "ms-rrhh" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9007, priority = "medium"
  }

  "ms-activos-fijos" = {
    memory_limit = "384Mi", memory_request = "256Mi"
    cpu_limit = "250m", cpu_request = "100m"
    jvm_xms = "192m", jvm_xmx = "320m"
    replicas = 1, port = 9008, priority = "low"
  }

  "ms-produccion" = {
    memory_limit = "384Mi", memory_request = "256Mi"
    cpu_limit = "250m", cpu_request = "100m"
    jvm_xms = "192m", jvm_xmx = "320m"
    replicas = 1, port = 9009, priority = "low"
  }

  "ms-auditoria" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9011, priority = "medium"
  }

  "ms-reportes" = {
    memory_limit = "768Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "512m"
    replicas = 1, port = 9012, priority = "medium"
  }

  "ms-notificaciones" = {
    memory_limit = "384Mi", memory_request = "256Mi"
    cpu_limit = "250m", cpu_request = "100m"
    jvm_xms = "192m", jvm_xmx = "320m"
    replicas = 1, port = 9013, priority = "low"
  }
}

generate_docker_compose = false
