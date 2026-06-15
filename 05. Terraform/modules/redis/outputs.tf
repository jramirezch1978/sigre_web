output "host" {
  description = "Host de Redis"
  value       = google_redis_instance.main.host
  sensitive   = true
}

output "port" {
  description = "Puerto de Redis"
  value       = google_redis_instance.main.port
}

output "instance_name" {
  description = "Nombre de la instancia Redis"
  value       = google_redis_instance.main.name
}
