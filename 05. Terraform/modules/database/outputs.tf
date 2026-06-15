output "connection_name" {
  description = "Connection name de Cloud SQL"
  value       = google_sql_database_instance.main.connection_name
}

output "private_ip" {
  description = "IP privada de Cloud SQL"
  value       = google_sql_database_instance.main.private_ip_address
  sensitive   = true
}

output "instance_name" {
  description = "Nombre de la instancia Cloud SQL"
  value       = google_sql_database_instance.main.name
}
