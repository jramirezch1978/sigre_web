# ============================================================
# Módulo: Networking — VPC, Subnets, Firewall
# ============================================================

resource "google_compute_network" "vpc" {
  name                    = "rpe-vpc-${var.environment}"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "main" {
  name          = "rpe-subnet-main-${var.environment}"
  ip_cidr_range = "10.10.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.30.0.0/20"
  }
}

resource "google_compute_global_address" "private_ip" {
  name          = "rpe-private-ip-${var.environment}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]
}

# ── Firewall Rules ────────────────────────────────────────

resource "google_compute_firewall" "allow_internal" {
  name    = "rpe-allow-internal-${var.environment}"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.10.0.0/20", "10.20.0.0/16", "10.30.0.0/20"]
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "rpe-allow-health-${var.environment}"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8761", "9001-9013"]
  }

  # Rangos de IP de los health checks de GCP
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}
