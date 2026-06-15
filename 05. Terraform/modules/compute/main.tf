# ============================================================
# Módulo: Compute — GCE VM (servidor único)
# ============================================================
# Provisiona una instancia GCE con las especificaciones
# definidas en server_spec (RAM, CPU, disco).
#
# Uso: para ambientes donde no se justifica un cluster GKE
# (dev, staging con servidor único).
#
# La VM viene con Docker + Docker Compose pre-instalados.
# ============================================================

locals {
  # Mapeo de server_spec a machine_type de GCE
  # custom-{cpus}-{memory_mb}
  machine_type = "custom-${var.server_spec.cpu_cores}-${var.server_spec.ram_gb * 1024}"
}

resource "google_compute_instance" "server" {
  name         = "rpe-server-${var.environment}"
  machine_type = local.machine_type
  zone         = var.zone
  project      = var.project_id

  tags = ["rpe-server", var.environment]

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/family/cos-stable"
      size  = var.server_spec.disk_gb
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnet_id

    # IP pública solo en dev
    dynamic "access_config" {
      for_each = var.environment == "dev" ? [1] : []
      content {
        // IP efímera
      }
    }
  }

  # Startup script: instalar Docker y Docker Compose
  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    set -euo pipefail

    # Container-Optimized OS ya tiene Docker
    # Instalar Docker Compose v2
    if ! docker compose version &>/dev/null; then
      COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
      mkdir -p /usr/local/lib/docker/cli-plugins
      curl -SL "https://github.com/docker/compose/releases/download/$${COMPOSE_VERSION}/docker-compose-linux-x86_64" \
        -o /usr/local/lib/docker/cli-plugins/docker-compose
      chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    fi

    echo "Docker y Docker Compose instalados correctamente."
  SCRIPT

  metadata = {
    ssh-keys                 = var.ssh_public_key != "" ? "deploy:${var.ssh_public_key}" : null
    enable-oslogin           = "TRUE"
    block-project-ssh-keys   = var.environment == "prod" ? "TRUE" : "FALSE"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  scheduling {
    # Preemptible en dev para ahorro
    preemptible       = var.environment == "dev"
    automatic_restart = var.environment != "dev"
  }

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    ram_gb      = tostring(var.server_spec.ram_gb)
    cpu_cores   = tostring(var.server_spec.cpu_cores)
    disk_gb     = tostring(var.server_spec.disk_gb)
    managed-by  = "terraform"
  }

  allow_stopping_for_update = true
}

# ── Firewall: permitir acceso a los puertos de los servicios ─

resource "google_compute_firewall" "server_services" {
  name    = "rpe-server-services-${var.environment}"
  network = var.network_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports = [
      "22",          # SSH
      "80", "443",   # HTTP/HTTPS
      "8080",        # API Gateway
      "8761",        # Eureka
      "8888",        # Config Server
      "5432",        # PostgreSQL
      "5672",        # RabbitMQ AMQP
      "15672",       # RabbitMQ Management
      "6379",        # Redis
      "9001-9013",   # Microservicios
      "9090",        # Prometheus
      "9200",        # Elasticsearch
      "9411",        # Zipkin
      "3000",        # Grafana
      "5601",        # Kibana
    ]
  }

  # En prod, solo desde IPs internas
  source_ranges = var.environment == "prod" ? ["10.10.0.0/20"] : ["0.0.0.0/0"]

  target_tags = ["rpe-server"]
}

# ── Disco adicional para datos (PostgreSQL, Elasticsearch) ───

resource "google_compute_disk" "data" {
  name    = "rpe-data-${var.environment}"
  type    = "pd-ssd"
  zone    = var.zone
  project = var.project_id
  size    = max(100, var.server_spec.disk_gb - 100) # Disco de datos separado

  labels = {
    environment = var.environment
    project     = "restaurant-pe"
    purpose     = "data"
  }
}

resource "google_compute_attached_disk" "data" {
  disk     = google_compute_disk.data.id
  instance = google_compute_instance.server.id
}
