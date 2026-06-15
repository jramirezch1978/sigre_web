# ============================================================
# Restaurant.pe ERP — Ambiente de DESARROLLO + PRUEBAS
# ============================================================
# Servidor: 16 GB RAM | 8 cores | 800 GB SSD
# Despliegue: servidor único con Docker Compose
# Propósito: desarrollo diario + ejecución de pruebas
#            (unitarias, integración, E2E, calidad de código)
#
# ┌──────────────────────────────────────────────────────────────┐
# │ COMPONENTE                    │  RAM     │ CPU  │ DISCO      │
# ├───────────────────────────────┼─────────-┼──────┼────────────┤
# │ SO + Docker overhead          │  1.50 GB │  —   │   30 GB    │
# │ PostgreSQL 16                 │  3.50 GB │ 1.75 │  250 GB    │
# │ RabbitMQ 3.13                 │  0.50 GB │ 0.50 │   10 GB    │
# │ Redis 7                       │  0.25 GB │ 0.25 │    2 GB    │
# │ Eureka + Config + Gateway     │  0.90 GB │ 1.00 │    —       │
# │ 10 ms negocio (JVM)           │  4.20 GB │ 3.50 │    —       │
# │ 3 ms soporte (JVM)            │  1.10 GB │ 0.65 │    —       │
# │ Testing (perfil)              │  2.55 GB │ 1.50 │   30 GB    │
# │   └ SonarQube 10 CE           │  2.00 GB │ 1.00 │   25 GB    │
# │   └ Selenium Hub              │  0.25 GB │ 0.25 │    —       │
# │   └ Selenium Chrome           │  0.50 GB │ 0.50 │    5 GB    │
# │ Observabilidad (perfil)       │  2.30 GB │ 2.00 │   75 GB    │
# │ Backups + Logs + Docker       │    —     │  —   │  235 GB    │
# │ Reserva libre                 │  1.20 GB │  —   │  168 GB    │
# ├───────────────────────────────┼──────────┼──────┼────────────┤
# │ TOTAL (sin perfiles)          │ 11.95 GB │ 7.65 │  800 GB    │
# │ TOTAL (con 1 perfil)          │~14.5  GB │~8.0  │  800 GB    │
# │ TOTAL (2 perfiles = pico)     │~16.8  GB │~8.0  │  800 GB    │
# └───────────────────────────────┴──────────┴──────┴────────────┘
#
# NOTA: Los 2 perfiles (testing + observability) pueden correr
# simultáneamente con overcommit controlado (los limits suman
# ~16.8 GB pero los requests suman ~12 GB). Para uso intensivo
# de pruebas, se recomienda activar solo 1 perfil a la vez.
# ============================================================

project_id  = "restaurant-pe-dev"
region      = "us-east1"
environment = "dev"

# ── Servidor ─────────────────────────────────────────────────

server_spec = {
  ram_gb    = 16
  cpu_cores = 8
  disk_gb   = 800
}

# ── Distribución de disco (800 GB) ──────────────────────────

disk_allocation = {
  postgres      = 250  # Datos PG (master + template + N empresas + test DBs)
  elasticsearch = 50   # Logs indexados (retención 15 días)
  prometheus    = 20   # Métricas time series (retención 15 días)
  rabbitmq      = 10   # Mensajes en tránsito + DLQ
  redis         = 2    # Snapshots de caché
  grafana       = 2    # Dashboards + datasources
  sonarqube     = 25   # SonarQube CE data (métricas, issues, coverage)
  testing       = 5    # Artefactos de test, reportes JaCoCo, screenshots Selenium
  backups       = 150  # pg_dump diario + WAL archiving
  logs          = 50   # Logback archivos rotativos
  docker        = 40   # 16 imágenes JRE + SonarQube + Selenium + infra
  os_swap       = 30   # SO + 4 GB swap
}

# ── Database (Cloud SQL o local) ─────────────────────────────

db_tier      = "db-custom-2-7168"  # 2 vCPU, 7 GB RAM
db_disk_size = 250

# ── PostgreSQL Tuning (para 3.5 GB contenedor, SSD, 8 cores)
# Ajustado para dev+test: más conexiones (test runners, SonarQube)

pg_tuning = {
  shared_buffers_mb            = 1280  # 37% de 3.5 GB del contenedor
  effective_cache_size_mb      = 2688  # 75% de 3.5 GB (PG + OS cache)
  work_mem_mb                  = 12    # Conservador: 250 conn × 12 MB = 3 GB worst case
  maintenance_work_mem_mb      = 192   # VACUUM, CREATE INDEX
  wal_buffers_mb               = 48    # Proporcional a shared_buffers
  max_connections              = 250   # 16 ms × pool ~10 + SonarQube + test runners + admin
  max_parallel_workers         = 4     # 50% de 8 cores
  max_parallel_workers_gather  = 2     # Máx por query paralelo
  max_parallel_maintenance     = 2     # VACUUM/INDEX paralelo
  random_page_cost             = 1.1   # SSD (no HDD = 4.0)
  effective_io_concurrency     = 200   # SSD
  checkpoint_completion_target = 0.9   # Spread I/O del checkpoint
  autovacuum_scale_factor      = 0.05  # Agresivo: vacuum al 5% de rows muertas
  log_min_duration_ms          = 500   # Loguear queries > 500ms
  timezone                     = "America/Lima"
}

# ── PostgreSQL Container Resources ───────────────────────────
# Reducido de 4 GB a 3.5 GB para liberar RAM al perfil testing

postgres_resources = {
  memory_limit   = "3584Mi"  # 3.5 GB para PostgreSQL
  memory_request = "2048Mi"
  cpu_limit      = "1750m"   # 1.75 cores
  cpu_request    = "1000m"
}

# ── RabbitMQ Resources ───────────────────────────────────────

rabbitmq_resources = {
  memory_limit   = "512Mi"
  memory_request = "256Mi"
  cpu_limit      = "500m"
  cpu_request    = "250m"
  replicas       = 1  # Nodo único en dev
}

# ── Redis Resources ──────────────────────────────────────────

redis_resources = {
  memory_gb    = 1    # Memorystore 1 GB
  maxmemory_mb = 200  # maxmemory policy allkeys-lru
}

# ── Observabilidad Resources ─────────────────────────────────
# En dev se activan con --profile observability

observability_resources = {
  elasticsearch = {
    memory_limit   = "1024Mi"
    memory_request = "768Mi"
    cpu_limit      = "1000m"
    heap_mb        = 512
    replicas       = 1
  }
  kibana = {
    memory_limit = "384Mi"
  }
  prometheus = {
    memory_limit   = "384Mi"
    retention_days = 15
  }
  grafana = {
    memory_limit = "256Mi"
  }
  zipkin = {
    memory_limit = "256Mi"
    jvm_xms      = "64m"
    jvm_xmx      = "128m"
  }
}

# ── Testing Resources ─────────────────────────────────────────
# En dev se activan con --profile testing
# SonarQube usa la BD 'sonarqube' creada en 01-init-security.sql
# Selenium Grid para tests E2E del frontend

testing_resources = {
  sonarqube = {
    memory_limit   = "2048Mi"   # SonarQube CE necesita mín 2 GB
    memory_request = "1536Mi"
    cpu_limit      = "1000m"    # 1 core
    enabled        = true
  }
  selenium_hub = {
    memory_limit = "256Mi"
    cpu_limit    = "250m"
  }
  selenium_chrome = {
    memory_limit = "512Mi"
    cpu_limit    = "500m"
    max_sessions = 2            # 2 sesiones paralelas
    shm_size     = "256m"       # /dev/shm para Chrome headless
  }
}

# ── GKE (NO se usa en dev — servidor único) ──────────────────

gke_node_count   = 0
gke_machine_type = "e2-standard-2"
gke_min_nodes    = 0
gke_max_nodes    = 0
gke_disk_size_gb = 50

# ── Microservicios — Distribución de recursos ────────────────
# FUENTE ÚNICA DE VERDAD para RAM, CPU y JVM de cada servicio.
# Criterio de prioridad:
#   critical → servicios de infraestructura + auth (siempre deben estar up)
#   high     → servicios más demandados (core, ventas, contabilidad)
#   medium   → servicios operativos (almacen, compras, finanzas, rrhh)
#   low      → servicios secundarios/batch (activos, produccion)

microservice_resources = {

  # ── INFRAESTRUCTURA SPRING CLOUD ─────────────────────────

  "eureka-server" = {
    memory_limit   = "256Mi"
    memory_request = "192Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "128m"
    jvm_xmx        = "192m"
    replicas       = 1
    port           = 8761
    priority       = "critical"
  }

  "config-server" = {
    memory_limit   = "256Mi"
    memory_request = "192Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "128m"
    jvm_xmx        = "192m"
    replicas       = 1
    port           = 8888
    priority       = "critical"
  }

  "api-gateway" = {
    memory_limit   = "384Mi"
    memory_request = "256Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "192m"
    jvm_xmx        = "320m"
    replicas       = 1
    port           = 8080
    priority       = "critical"
  }

  # ── NEGOCIO: PRIORIDAD ALTA (512 Mi) ────────────────────

  "ms-auth-security" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "256m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9001
    priority       = "critical"
  }

  "ms-core-maestros" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "256m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9002
    priority       = "high"
  }

  "ms-ventas" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "256m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9010
    priority       = "high"
  }

  "ms-contabilidad" = {
    memory_limit   = "512Mi"
    memory_request = "384Mi"
    cpu_limit      = "500m"
    cpu_request    = "200m"
    jvm_xms        = "256m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9006
    priority       = "high"
  }

  # ── NEGOCIO: PRIORIDAD MEDIA (384 Mi) ──────────────────

  "ms-almacen" = {
    memory_limit   = "384Mi"
    memory_request = "256Mi"
    cpu_limit      = "250m"
    cpu_request    = "150m"
    jvm_xms        = "192m"
    jvm_xmx        = "320m"
    replicas       = 1
    port           = 9003
    priority       = "medium"
  }

  "ms-compras" = {
    memory_limit   = "384Mi"
    memory_request = "256Mi"
    cpu_limit      = "250m"
    cpu_request    = "150m"
    jvm_xms        = "192m"
    jvm_xmx        = "320m"
    replicas       = 1
    port           = 9004
    priority       = "medium"
  }

  "ms-finanzas" = {
    memory_limit   = "384Mi"
    memory_request = "256Mi"
    cpu_limit      = "250m"
    cpu_request    = "150m"
    jvm_xms        = "192m"
    jvm_xmx        = "320m"
    replicas       = 1
    port           = 9005
    priority       = "medium"
  }

  "ms-rrhh" = {
    memory_limit   = "384Mi"
    memory_request = "256Mi"
    cpu_limit      = "250m"
    cpu_request    = "150m"
    jvm_xms        = "192m"
    jvm_xmx        = "320m"
    replicas       = 1
    port           = 9007
    priority       = "medium"
  }

  # ── NEGOCIO: PRIORIDAD NORMAL (320 Mi) ─────────────────

  "ms-activos-fijos" = {
    memory_limit   = "320Mi"
    memory_request = "192Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "128m"
    jvm_xmx        = "256m"
    replicas       = 1
    port           = 9008
    priority       = "low"
  }

  "ms-produccion" = {
    memory_limit   = "320Mi"
    memory_request = "192Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "128m"
    jvm_xmx        = "256m"
    replicas       = 1
    port           = 9009
    priority       = "low"
  }

  # ── SOPORTE ────────────────────────────────────────────

  "ms-auditoria" = {
    memory_limit   = "320Mi"
    memory_request = "192Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "128m"
    jvm_xmx        = "256m"
    replicas       = 1
    port           = 9011
    priority       = "medium"
  }

  "ms-reportes" = {
    memory_limit   = "512Mi"
    memory_request = "256Mi"
    cpu_limit      = "250m"
    cpu_request    = "100m"
    jvm_xms        = "192m"
    jvm_xmx        = "384m"
    replicas       = 1
    port           = 9012
    priority       = "medium"
  }

  "ms-notificaciones" = {
    memory_limit   = "256Mi"
    memory_request = "128Mi"
    cpu_limit      = "150m"
    cpu_request    = "50m"
    jvm_xms        = "128m"
    jvm_xmx        = "192m"
    replicas       = 1
    port           = 9013
    priority       = "low"
  }
}

# ── Docker Compose generation ────────────────────────────────

generate_docker_compose    = true
docker_compose_output_path = "../02. Backend/docker-compose.generated.yml"
