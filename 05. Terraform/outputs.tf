# ============================================================
# SIGRE ERP — Outputs Terraform
# ============================================================

output "deployment_target" {
  description = "Modo de despliegue activo"
  value       = var.deployment_target
}

output "environment" {
  description = "Ambiente configurado"
  value       = var.environment
}

output "server_spec" {
  description = "Especificaciones del servidor"
  value       = var.server_spec
}

output "docker_stack" {
  description = "Configuración Docker cronos"
  value       = var.docker_stack
}

output "public_urls" {
  description = "URLs públicas de acceso"
  value = {
    frontend    = "http://${var.docker_stack.public_host}:${var.service_ports.frontend}"
    api_gateway = "http://${var.docker_stack.public_host}:${var.service_ports.api_gateway}"
    sonarqube   = "http://${var.docker_stack.public_host}:${var.service_ports.sonarqube}"
  }
}

output "generated_files" {
  description = "Archivos Docker Compose generados"
  value = var.generate_docker_compose && var.deployment_target == "docker-compose" ? {
    stack_compose = "${var.docker_compose_output_dir}/docker-compose.stack.yml"
    app_compose   = "${var.docker_compose_output_dir}/docker-compose.app.yml"
    env_example   = "${var.docker_compose_output_dir}/.env.example"
    deploy_script = "${var.docker_compose_output_dir}/deploy.bat"
    postgres_init = "${var.docker_compose_output_dir}/init/01-create-databases.sql"
  } : {}
}

output "resource_budget_mb" {
  description = "Presupuesto de RAM estimado (limits)"
  value = {
    postgres_mb      = local.postgres_memory_mb
    microservices_mb = local.app_memory_mb
    frontend_mb      = local.frontend_memory_mb
    sonarqube_mb      = local.sonarqube_memory_mb
    total_stack_mb   = local.total_app_stack_mb
    server_ram_mb    = var.server_spec.ram_gb * 1024
    headroom_mb      = (var.server_spec.ram_gb * 1024) - local.total_app_stack_mb
  }
}

output "enabled_services" {
  description = "Servicios backend habilitados en Fase 1"
  value       = keys(local.enabled_microservices)
}

# ── GCP (legacy) ─────────────────────────────────────────────

output "vpc_id" {
  value = var.deployment_target == "gcp" ? try(module.networking[0].vpc_id, "N/A") : "N/A (docker-compose)"
}

output "database_connection_name" {
  value     = var.deployment_target == "gcp" ? try(module.database[0].connection_name, "N/A") : "N/A"
  sensitive = true
}

output "database_tuning_summary" {
  value = {
    shared_buffers  = "${var.pg_tuning.shared_buffers_mb} MB"
    max_connections = var.pg_tuning.max_connections
    timezone        = var.pg_tuning.timezone
  }
}
