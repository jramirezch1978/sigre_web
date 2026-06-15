# ============================================================
# Módulo: Kubernetes — GKE Cluster
# ============================================================
# Cluster GKE para desplegar los 16 microservicios.
# Incluye autoscaling y nodos preemptibles en dev.
# ============================================================

resource "google_container_cluster" "primary" {
  name     = "rpe-gke-${var.environment}"
  location = var.region
  project  = var.project_id

  # Usar node pool separado
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  # Workload Identity (seguridad)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Logging y monitoring
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  # Release channel
  release_channel {
    channel = var.environment == "prod" ? "STABLE" : "REGULAR"
  }
}

# ── Node Pool principal ───────────────────────────────────

resource "google_container_node_pool" "primary_nodes" {
  name       = "rpe-nodepool-${var.environment}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  node_count = var.node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 50
    disk_type    = "pd-standard"

    # Nodos preemptibles en dev (ahorro de costo)
    preemptible = var.environment == "dev" ? true : false
    spot        = var.environment == "dev" ? true : false

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      environment = var.environment
      project     = "restaurant-pe"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
