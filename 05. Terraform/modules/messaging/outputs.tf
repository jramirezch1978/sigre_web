# ============================================================
# Módulo: Messaging — Outputs
# ============================================================

output "rabbitmq_release_name" {
  description = "Nombre del release Helm de RabbitMQ"
  value       = helm_release.rabbitmq.name
}

output "rabbitmq_namespace" {
  description = "Namespace donde se desplegó RabbitMQ"
  value       = helm_release.rabbitmq.namespace
}

output "rabbitmq_resource_summary" {
  description = "Resumen de recursos asignados a RabbitMQ"
  value = {
    memory_limit   = var.rabbitmq_resources.memory_limit
    memory_request = var.rabbitmq_resources.memory_request
    cpu_limit      = var.rabbitmq_resources.cpu_limit
    replicas       = var.rabbitmq_resources.replicas
    disk_gb        = var.disk_gb
  }
}
