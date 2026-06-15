output "vpc_id" {
  description = "ID de la VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Nombre de la VPC"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "ID de la subnet principal"
  value       = google_compute_subnetwork.main.id
}

output "subnet_name" {
  description = "Nombre de la subnet principal"
  value       = google_compute_subnetwork.main.name
}
