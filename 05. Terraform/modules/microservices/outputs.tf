# ============================================================
# Módulo: Microservices — Outputs
# ============================================================

output "namespace" {
  description = "Namespace de Kubernetes donde se desplegaron los servicios"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "service_endpoints" {
  description = "Endpoints internos de cada microservicio (ClusterIP)"
  value = {
    for name, svc in kubernetes_service.service :
    name => "${svc.metadata[0].name}.${svc.metadata[0].namespace}.svc.cluster.local:${svc.spec[0].port[0].port}"
  }
}

output "deployment_names" {
  description = "Nombres de los Deployments creados"
  value       = [for name, dep in kubernetes_deployment.service : dep.metadata[0].name]
}

output "resource_summary" {
  description = "Resumen de recursos asignados por servicio"
  value = {
    for name, svc in var.services :
    name => {
      memory_limit = svc.memory_limit
      cpu_limit    = svc.cpu_limit
      jvm_heap     = "${svc.jvm_xms}-${svc.jvm_xmx}"
      replicas     = svc.replicas
      priority     = svc.priority
    }
  }
}
