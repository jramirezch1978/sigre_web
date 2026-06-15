# ============================================================
# Módulo: Redis — Google Memorystore
# ============================================================
# Redis para: caché de sesiones JWT, rate limiting, blacklist.
# ============================================================

resource "google_redis_instance" "main" {
  name           = "rpe-redis-${var.environment}"
  tier           = var.environment == "prod" ? "STANDARD_HA" : "BASIC"
  memory_size_gb = var.memory_size
  region         = var.region
  project        = var.project_id

  authorized_network = var.network_id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version = "REDIS_7_0"

  redis_configs = {
    maxmemory-policy = "allkeys-lru"
    notify-keyspace-events = "Ex"
  }

  maintenance_policy {
    weekly_maintenance_window {
      day = "SUNDAY"
      start_time {
        hours   = 4
        minutes = 0
      }
    }
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
  }
}
