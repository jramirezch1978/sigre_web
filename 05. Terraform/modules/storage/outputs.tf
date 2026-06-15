output "backup_bucket_name" {
  description = "Nombre del bucket de backups"
  value       = google_storage_bucket.backups.name
}

output "reports_bucket_name" {
  description = "Nombre del bucket de reportes"
  value       = google_storage_bucket.reports.name
}

output "regulatory_bucket_name" {
  description = "Nombre del bucket regulatorio"
  value       = google_storage_bucket.regulatory.name
}

output "logs_bucket_name" {
  description = "Nombre del bucket de logs"
  value       = google_storage_bucket.logs.name
}
