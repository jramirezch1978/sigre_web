# ============================================================
# Módulo: Compute — Outputs
# ============================================================

output "instance_name" {
  description = "Nombre de la instancia GCE"
  value       = google_compute_instance.server.name
}

output "instance_id" {
  description = "ID de la instancia GCE"
  value       = google_compute_instance.server.instance_id
}

output "internal_ip" {
  description = "IP interna de la instancia"
  value       = google_compute_instance.server.network_interface[0].network_ip
}

output "external_ip" {
  description = "IP externa de la instancia (si tiene)"
  value       = try(google_compute_instance.server.network_interface[0].access_config[0].nat_ip, null)
}

output "machine_type" {
  description = "Tipo de máquina provisionada"
  value       = google_compute_instance.server.machine_type
}

output "server_spec_summary" {
  description = "Resumen de las especificaciones del servidor"
  value = {
    machine_type = google_compute_instance.server.machine_type
    ram_gb       = var.server_spec.ram_gb
    cpu_cores    = var.server_spec.cpu_cores
    disk_gb      = var.server_spec.disk_gb
  }
}
