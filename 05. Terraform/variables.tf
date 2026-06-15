# ============================================================
# SIGRE ERP — Variables globales de Terraform
# ============================================================
# Fuente única de verdad para RAM, CPU, disco y servicios
# desplegados en Docker Compose (servidor cronos) o GCP.
# ============================================================

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GENERAL
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "project_id" {
  description = "ID del proyecto GCP (solo si deployment_target = gcp)"
  type        = string
  default     = "sigre-erp"
}

variable "region" {
  description = "Región GCP (solo si deployment_target = gcp)"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Ambiente: cronos, dev, staging, prod"
  type        = string
  validation {
    condition     = contains(["cronos", "dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser: cronos, dev, staging o prod."
  }
}

variable "deployment_target" {
  description = "docker-compose (cronos/servidor único) o gcp (GKE + Cloud SQL)"
  type        = string
  default     = "docker-compose"
  validation {
    condition     = contains(["docker-compose", "gcp"], var.deployment_target)
    error_message = "deployment_target debe ser docker-compose o gcp."
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CRONOS — SERVidor Docker
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "server_spec" {
  description = "Especificaciones físicas del servidor objetivo"
  type = object({
    ram_gb    = number
    cpu_cores = number
    disk_gb   = number
    hostname  = string
    ip_local  = string
  })
  default = {
    ram_gb    = 10
    cpu_cores = 4
    disk_gb   = 300
    hostname  = "cronos"
    ip_local  = "192.168.0.163"
  }
}

variable "docker_stack" {
  description = "Configuración del stack Docker en el servidor cronos"
  type = object({
    network_name       = string
    stack_dir          = string
    repo_dir           = string
    docker_data_root   = string
    docker_context     = string
    public_host        = string
    public_ip          = string
    timezone           = string
    app_user           = string
  })
  default = {
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
}

variable "image_registry" {
  description = "Registry de imágenes pre-construidas (build fuera del servidor)"
  type        = string
  default     = "ghcr.io/jramirezch1978/sigre"
}

variable "image_tag" {
  description = "Tag de imágenes Docker"
  type        = string
  default     = "latest"
}

variable "use_prebuilt_images" {
  description = "true = pull de registry; false = build local (no recomendado en cronos)"
  type        = bool
  default     = true
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PUERTOS EXPUESTOS (NAT router → cronos)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "service_ports" {
  description = "Puertos publicados en el host"
  type = object({
    frontend   = number
    api_gateway = number
    postgres   = number
    sonarqube  = number
    eureka     = number
  })
  default = {
    frontend    = 8080
    api_gateway = 9080
    postgres    = 5432
    sonarqube   = 9000
    eureka      = 8761
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DISTRIBUCIÓN DE DISCO
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "disk_allocation" {
  description = "Distribución de disco en GB por componente"
  type = object({
    postgres  = number
    sonarqube = number
    backups   = number
    logs      = number
    docker    = number
    os_swap   = number
  })
  default = {
    postgres  = 80
    sonarqube = 15
    backups   = 50
    logs      = 10
    docker    = 30
    os_swap   = 20
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# POSTGRESQL 17
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "postgres_config" {
  description = "Configuración del contenedor PostgreSQL 17 (stack de infraestructura)"
  type = object({
    container_name = string
    service_name   = string
    image          = string
    superuser      = string
    databases      = list(string)
    init_scripts   = list(string)
    shm_size       = optional(string, "256mb")
  })
  default = {
    container_name = "postgres17"
    service_name   = "postgres"
    image          = "postgres:17"
    superuser      = "postgres"
    databases      = ["sigre_security", "sigre_template"]
    init_scripts = [
      "04. Base de datos/ddl/security/00-convenciones-security.sql",
      "04. Base de datos/ddl/security/01-master.sql",
      "04. Base de datos/ddl/security/02-config.sql",
      "04. Base de datos/ddl/security/03-auth.sql",
    ]
  }
}

variable "pg_tuning" {
  description = "Parámetros de tuning PostgreSQL"
  type = object({
    shared_buffers_mb            = number
    effective_cache_size_mb      = number
    work_mem_mb                  = number
    maintenance_work_mem_mb      = number
    wal_buffers_mb               = number
    max_connections              = number
    max_parallel_workers         = number
    max_parallel_workers_gather  = number
    max_parallel_maintenance     = number
    random_page_cost             = number
    effective_io_concurrency     = number
    checkpoint_completion_target = number
    autovacuum_scale_factor      = number
    log_min_duration_ms          = number
    timezone                     = string
  })
  default = {
    shared_buffers_mb            = 512
    effective_cache_size_mb      = 1536
    work_mem_mb                  = 8
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
}

variable "postgres_resources" {
  description = "Recursos del contenedor PostgreSQL"
  type = object({
    memory_limit   = string
    memory_request = string
    cpu_limit      = string
    cpu_request    = string
  })
  default = {
    memory_limit   = "2048Mi"
    memory_request = "1536Mi"
    cpu_limit      = "1500m"
    cpu_request    = "500m"
  }
}

variable "db_admin_password" {
  description = "Contraseña superusuario PostgreSQL"
  type        = string
  sensitive   = true
  default     = "CHANGE_ME_POSTGRES"
}

variable "erp_app_password" {
  description = "Contraseña del rol erp_app en PostgreSQL"
  type        = string
  sensitive   = true
  default     = "CHANGE_ME_ERP_APP"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FRONTEND ANGULAR
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "frontend_resources" {
  description = "Recursos del contenedor frontend (nginx + Angular estático)"
  type = object({
    memory_limit = string
    cpu_limit    = string
    image_name   = string
    container_name = string
  })
  default = {
    memory_limit   = "128Mi"
    cpu_limit      = "250m"
    image_name     = "sigre-frontend"
    container_name = "sigre-frontend"
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SONARQUBE (perfil tools — bajo demanda)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "sonarqube_db_password" {
  description = "Contraseña del rol sonarqube en PostgreSQL"
  type        = string
  sensitive   = true
  default     = "CHANGE_ME_SONARQUBE"
}

variable "testing_resources" {
  description = "Recursos para SonarQube (perfil tools)"
  type = object({
    sonarqube = object({
      memory_limit   = string
      memory_request = string
      cpu_limit      = string
      enabled        = bool
      image          = string
      container_name = string
      restart        = optional(string, "no")
      host_port      = optional(number, 9001)
      jdbc_username  = optional(string, "sonarqube")
    })
  })
  default = {
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
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MICROSERVICIOS BACKEND (Fase 1 SIGRE)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "microservice_resources" {
  description = "Servicios Java/Spring Boot desplegados en docker-compose.app.yml"
  type = map(object({
    memory_limit   = string
    memory_request = string
    cpu_limit      = string
    cpu_request    = string
    jvm_xms        = string
    jvm_xmx        = string
    replicas       = number
    port           = number
    priority       = string
    image_name     = string
    container_name = string
    enabled        = bool
    expose_port    = bool
    db_name        = optional(string, "sigre_emp_cantabria")
  }))
  default = {
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
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GCP (legacy — solo deployment_target = gcp)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "db_tier" {
  type    = string
  default = "db-custom-2-7680"
}

variable "db_disk_size" {
  type    = number
  default = 50
}

variable "gke_node_count" {
  type    = number
  default = 0
}

variable "gke_machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "gke_min_nodes" {
  type    = number
  default = 0
}

variable "gke_max_nodes" {
  type    = number
  default = 0
}

variable "gke_disk_size_gb" {
  type    = number
  default = 50
}

variable "rabbitmq_user" {
  type    = string
  default = "sigre"
}

variable "rabbitmq_pass" {
  type      = string
  sensitive = true
  default   = "CHANGE_ME_RABBITMQ"
}

variable "rabbitmq_resources" {
  type = object({
    memory_limit   = string
    memory_request = string
    cpu_limit      = string
    cpu_request    = string
    replicas       = number
  })
  default = {
    memory_limit   = "512Mi"
    memory_request = "256Mi"
    cpu_limit      = "500m"
    cpu_request    = "250m"
    replicas       = 1
  }
}

variable "redis_resources" {
  type = object({
    memory_gb    = number
    maxmemory_mb = number
  })
  default = {
    memory_gb    = 1
    maxmemory_mb = 200
  }
}

variable "observability_resources" {
  type = object({
    elasticsearch = object({
      memory_limit   = string
      memory_request = string
      cpu_limit      = string
      heap_mb        = number
      replicas       = number
    })
    kibana = object({ memory_limit = string })
    prometheus = object({
      memory_limit   = string
      retention_days = number
    })
    grafana = object({ memory_limit = string })
    zipkin = object({
      memory_limit = string
      jvm_xms        = string
      jvm_xmx        = string
    })
  })
  default = {
    elasticsearch = {
      memory_limit   = "1024Mi"
      memory_request = "768Mi"
      cpu_limit      = "1000m"
      heap_mb        = 512
      replicas       = 1
    }
    kibana         = { memory_limit = "384Mi" }
    prometheus     = { memory_limit = "384Mi", retention_days = 15 }
    grafana        = { memory_limit = "256Mi" }
    zipkin         = { memory_limit = "256Mi", jvm_xms = "64m", jvm_xmx = "128m" }
  }
}

variable "grafana_password" {
  type      = string
  sensitive = true
  default   = "admin"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SALIDA DE ARCHIVOS GENERADOS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

variable "generate_docker_compose" {
  description = "Generar docker-compose.stack.yml y docker-compose.app.yml"
  type        = bool
  default     = true
}

variable "docker_compose_output_dir" {
  description = "Directorio donde se escriben los compose generados"
  type        = string
  default     = "../deploy/cronos"
}
