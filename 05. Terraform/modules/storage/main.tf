# ============================================================
# Módulo: Storage — GCS Buckets
# ============================================================
# Buckets para: backups, reportes, archivos SUNAT, logs.
# ============================================================

# ── Bucket: Backups de BD ─────────────────────────────────

resource "google_storage_bucket" "backups" {
  name     = "rpe-backups-${var.environment}-${var.project_id}"
  location = var.region
  project  = var.project_id

  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.environment == "prod" ? 90 : 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = var.environment == "prod" ? 365 : 90
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    purpose     = "backups"
  }
}

# ── Bucket: Reportes generados ────────────────────────────

resource "google_storage_bucket" "reports" {
  name     = "rpe-reports-${var.environment}-${var.project_id}"
  location = var.region
  project  = var.project_id

  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    purpose     = "reports"
  }
}

# ── Bucket: Archivos regulatorios (SUNAT, PLAME, PLE) ────

resource "google_storage_bucket" "regulatory" {
  name     = "rpe-regulatory-${var.environment}-${var.project_id}"
  location = var.region
  project  = var.project_id

  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.environment == "prod" ? 1825 : 365 # 5 años en prod
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    purpose     = "regulatory"
  }
}

# ── Bucket: Logs (archivado a largo plazo) ────────────────

resource "google_storage_bucket" "logs" {
  name     = "rpe-logs-${var.environment}-${var.project_id}"
  location = var.region
  project  = var.project_id

  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    purpose     = "logs"
  }
}
