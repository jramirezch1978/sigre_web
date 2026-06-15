# ============================================================
# Módulo: Database — Cloud SQL PostgreSQL 16
# ============================================================
# Crea la instancia Cloud SQL con tuning parametrizado.
# Todos los valores de tuning provienen de var.pg_tuning
# (fuente única de verdad: Terraform variables/tfvars).
# ============================================================

resource "google_sql_database_instance" "main" {
  name             = "rpe-postgres-${var.environment}"
  database_version = "POSTGRES_16"
  region           = var.region
  project          = var.project_id

  deletion_protection = var.environment == "prod" ? true : false

  settings {
    tier      = var.db_tier
    disk_size = var.db_disk_size
    disk_type = "PD_SSD"

    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = var.environment == "prod" ? true : false
      transaction_log_retention_days = var.environment == "prod" ? 7 : 3

      backup_retention_settings {
        retained_backups = var.environment == "prod" ? 30 : 7
      }
    }

    maintenance_window {
      day          = 7 # Domingo
      hour         = 4
      update_track = "stable"
    }

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # PostgreSQL Tuning — parametrizado desde Terraform
    # Fuente única de verdad: var.pg_tuning
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    # ── Memoria ────────────────────────────────────────────
    database_flags {
      name  = "shared_buffers"
      value = "${var.pg_tuning.shared_buffers_mb}MB"
    }

    database_flags {
      name  = "effective_cache_size"
      value = "${var.pg_tuning.effective_cache_size_mb}MB"
    }

    database_flags {
      name  = "work_mem"
      value = "${var.pg_tuning.work_mem_mb}MB"
    }

    database_flags {
      name  = "maintenance_work_mem"
      value = "${var.pg_tuning.maintenance_work_mem_mb}MB"
    }

    database_flags {
      name  = "wal_buffers"
      value = "${var.pg_tuning.wal_buffers_mb}MB"
    }

    # ── Conexiones ─────────────────────────────────────────
    database_flags {
      name  = "max_connections"
      value = tostring(var.pg_tuning.max_connections)
    }

    # ── Paralelismo ────────────────────────────────────────
    database_flags {
      name  = "max_parallel_workers"
      value = tostring(var.pg_tuning.max_parallel_workers)
    }

    database_flags {
      name  = "max_parallel_workers_per_gather"
      value = tostring(var.pg_tuning.max_parallel_workers_gather)
    }

    database_flags {
      name  = "max_parallel_maintenance_workers"
      value = tostring(var.pg_tuning.max_parallel_maintenance)
    }

    database_flags {
      name  = "max_worker_processes"
      value = tostring(var.pg_tuning.max_parallel_workers * 2)
    }

    # ── Query Planner (SSD) ────────────────────────────────
    database_flags {
      name  = "random_page_cost"
      value = tostring(var.pg_tuning.random_page_cost)
    }

    database_flags {
      name  = "effective_io_concurrency"
      value = tostring(var.pg_tuning.effective_io_concurrency)
    }

    # ── WAL ────────────────────────────────────────────────
    database_flags {
      name  = "checkpoint_completion_target"
      value = tostring(var.pg_tuning.checkpoint_completion_target)
    }

    database_flags {
      name  = "wal_compression"
      value = "lz4"
    }

    # ── Autovacuum ─────────────────────────────────────────
    database_flags {
      name  = "autovacuum_vacuum_scale_factor"
      value = tostring(var.pg_tuning.autovacuum_scale_factor)
    }

    database_flags {
      name  = "autovacuum_analyze_scale_factor"
      value = tostring(var.pg_tuning.autovacuum_scale_factor)
    }

    # ── Logging ────────────────────────────────────────────
    database_flags {
      name  = "log_min_duration_statement"
      value = tostring(var.pg_tuning.log_min_duration_ms)
    }

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_statement"
      value = "ddl"
    }

    # ── Timezone ───────────────────────────────────────────
    database_flags {
      name  = "timezone"
      value = var.pg_tuning.timezone
    }

    # ── Replicación (preparado) ────────────────────────────
    database_flags {
      name  = "wal_level"
      value = "replica"
    }

    # ── Query Insights ─────────────────────────────────────
    insights_config {
      query_insights_enabled  = true
      query_plans_per_minute  = 5
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
  }
}

# ── Usuario admin ──────────────────────────────────────────

resource "google_sql_user" "admin" {
  name     = "restaurant_admin"
  instance = google_sql_database_instance.main.name
  password = var.db_admin_password
  project  = var.project_id
}

# ── BD Security ───────────────────────────────────────────

resource "google_sql_database" "security" {
  name     = "restaurant_pe_security"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

# ── BD Template ──────────────────────────────────────────

resource "google_sql_database" "template" {
  name     = "restaurant_pe_template"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

# ── BD Empresa Demo (solo dev/staging) ───────────────────

resource "google_sql_database" "demo" {
  count    = var.environment != "prod" ? 1 : 0
  name     = "restaurant_pe_emp_demo"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

# ── Réplica de lectura (solo producción) ─────────────────

resource "google_sql_database_instance" "read_replica" {
  count                = var.environment == "prod" ? 1 : 0
  name                 = "rpe-postgres-replica-${var.environment}"
  master_instance_name = google_sql_database_instance.main.name
  database_version     = "POSTGRES_16"
  region               = var.region
  project              = var.project_id

  replica_configuration {
    failover_target = false
  }

  settings {
    tier      = var.db_tier
    disk_size = var.db_disk_size
    disk_type = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }
}
