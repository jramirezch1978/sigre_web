# ============================================================
# Restaurant.pe ERP — Ambiente de PRODUCCIÓN
# ============================================================
# Infraestructura: GKE (4-10 nodos e2-standard-4, autoscaling)
# Cada nodo: 4 vCPU, 16 GB RAM → Total: 16-40 vCPU, 64-160 GB
# Cloud SQL: 4 vCPU, 16 GB RAM, 300 GB SSD, HA + Réplica
# Redis: HA 4 GB
# RabbitMQ: 3 réplicas
# ============================================================

project_id  = "restaurant-pe-prod"
region      = "us-east1"
environment = "prod"

# ── Servidor (referencia para GKE) ───────────────────────────

server_spec = {
  ram_gb    = 160  # 10 nodos máx × 16 GB
  cpu_cores = 40   # 10 nodos máx × 4 vCPU
  disk_gb   = 1000 # Cloud SQL + PVs + GCS
}

# ── Distribución de disco ────────────────────────────────────

disk_allocation = {
  postgres      = 300
  elasticsearch = 100
  prometheus    = 50
  rabbitmq      = 20
  redis         = 4
  grafana       = 10
  backups       = 200
  logs          = 100
  docker        = 50
  os_swap       = 30
}

# ── Database (Cloud SQL HA + réplica) ────────────────────────

db_tier      = "db-custom-4-16384"  # 4 vCPU, 16 GB RAM
db_disk_size = 300

# ── PostgreSQL Tuning (Cloud SQL 4 vCPU / 16 GB) ────────────

pg_tuning = {
  shared_buffers_mb            = 4096   # 25% de 16 GB
  effective_cache_size_mb      = 12288  # 75% de 16 GB
  work_mem_mb                  = 64     # Más espacio por query
  maintenance_work_mem_mb      = 1024   # VACUUM/INDEX rápidos
  wal_buffers_mb               = 128    # Proporcional
  max_connections              = 400    # Más servicios × más réplicas
  max_parallel_workers         = 4      # 4 cores disponibles
  max_parallel_workers_gather  = 2
  max_parallel_maintenance     = 2
  random_page_cost             = 1.1
  effective_io_concurrency     = 200
  checkpoint_completion_target = 0.9
  autovacuum_scale_factor      = 0.02   # Más agresivo en prod
  log_min_duration_ms          = 200    # Más detallado en prod
  timezone                     = "America/Lima"
}

postgres_resources = {
  memory_limit   = "16384Mi"
  memory_request = "8192Mi"
  cpu_limit      = "4000m"
  cpu_request    = "2000m"
}

# ── GKE ──────────────────────────────────────────────────────

gke_node_count   = 4
gke_machine_type = "e2-standard-4"
gke_min_nodes    = 3
gke_max_nodes    = 10
gke_disk_size_gb = 100

# ── RabbitMQ ─────────────────────────────────────────────────

rabbitmq_resources = {
  memory_limit   = "2048Mi"
  memory_request = "1024Mi"
  cpu_limit      = "1000m"
  cpu_request    = "500m"
  replicas       = 3  # Cluster HA
}

# ── Redis ────────────────────────────────────────────────────

redis_resources = {
  memory_gb    = 4
  maxmemory_mb = 3072
}

# ── Observabilidad ───────────────────────────────────────────

observability_resources = {
  elasticsearch = {
    memory_limit   = "4096Mi"
    memory_request = "2048Mi"
    cpu_limit      = "2000m"
    heap_mb        = 2048
    replicas       = 3  # Cluster ES
  }
  kibana = {
    memory_limit = "1024Mi"
  }
  prometheus = {
    memory_limit   = "1024Mi"
    retention_days = 90
  }
  grafana = {
    memory_limit = "512Mi"
  }
  zipkin = {
    memory_limit = "512Mi"
    jvm_xms      = "256m"
    jvm_xmx      = "384m"
  }
}

# ── Microservicios ───────────────────────────────────────────
# Producción: más réplicas para servicios críticos/high
# Mayor heap JVM para cargas reales

microservice_resources = {

  "eureka-server" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 3, port = 8761, priority = "critical"
  }

  "config-server" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 2, port = 8888, priority = "critical"
  }

  "api-gateway" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "1000m", cpu_request = "500m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 3, port = 8080, priority = "critical"
  }

  "ms-auth-security" = {
    memory_limit = "1024Mi", memory_request = "768Mi"
    cpu_limit = "1000m", cpu_request = "500m"
    jvm_xms = "512m", jvm_xmx = "768m"
    replicas = 3, port = 9001, priority = "critical"
  }

  "ms-core-maestros" = {
    memory_limit = "1024Mi", memory_request = "768Mi"
    cpu_limit = "1000m", cpu_request = "500m"
    jvm_xms = "512m", jvm_xmx = "768m"
    replicas = 3, port = 9002, priority = "high"
  }

  "ms-ventas" = {
    memory_limit = "1024Mi", memory_request = "768Mi"
    cpu_limit = "1000m", cpu_request = "500m"
    jvm_xms = "512m", jvm_xmx = "768m"
    replicas = 3, port = 9010, priority = "high"
  }

  "ms-contabilidad" = {
    memory_limit = "1024Mi", memory_request = "768Mi"
    cpu_limit = "1000m", cpu_request = "500m"
    jvm_xms = "512m", jvm_xmx = "768m"
    replicas = 2, port = 9006, priority = "high"
  }

  "ms-almacen" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9003, priority = "medium"
  }

  "ms-compras" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9004, priority = "medium"
  }

  "ms-finanzas" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9005, priority = "medium"
  }

  "ms-rrhh" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9007, priority = "medium"
  }

  "ms-activos-fijos" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9008, priority = "low"
  }

  "ms-produccion" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 1, port = 9009, priority = "low"
  }

  "ms-auditoria" = {
    memory_limit = "768Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "576m"
    replicas = 2, port = 9011, priority = "medium"
  }

  "ms-reportes" = {
    memory_limit = "1024Mi", memory_request = "512Mi"
    cpu_limit = "750m", cpu_request = "300m"
    jvm_xms = "384m", jvm_xmx = "768m"
    replicas = 2, port = 9012, priority = "medium"
  }

  "ms-notificaciones" = {
    memory_limit = "512Mi", memory_request = "384Mi"
    cpu_limit = "500m", cpu_request = "200m"
    jvm_xms = "256m", jvm_xmx = "384m"
    replicas = 2, port = 9013, priority = "low"
  }
}

generate_docker_compose = false
