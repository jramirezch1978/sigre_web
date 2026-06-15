# ============================================================
# Módulo: Database — Variables
# ============================================================

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "network_id" {
  description = "ID de la VPC"
  type        = string
}

variable "db_tier" {
  description = "Tier de Cloud SQL (e.g. db-custom-2-7680)"
  type        = string
}

variable "db_disk_size" {
  description = "Tamaño del disco (GB)"
  type        = number
}

variable "db_admin_password" {
  description = "Contraseña del admin"
  type        = string
  sensitive   = true
}

# ── PostgreSQL Tuning (proviene de pg_tuning en variables globales) ──

variable "pg_tuning" {
  description = "Parámetros de tuning de PostgreSQL"
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
}
