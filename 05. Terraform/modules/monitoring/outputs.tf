# ============================================================
# Módulo: Monitoring — Outputs
# ============================================================

output "monitoring_namespace" {
  description = "Namespace de monitoring"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "resource_summary" {
  description = "Resumen de recursos de observabilidad"
  value = {
    elasticsearch = {
      memory_limit = var.observability_resources.elasticsearch.memory_limit
      heap_mb      = var.observability_resources.elasticsearch.heap_mb
      replicas     = var.observability_resources.elasticsearch.replicas
      disk_gb      = var.disk_allocation.elasticsearch
    }
    prometheus = {
      memory_limit   = var.observability_resources.prometheus.memory_limit
      retention_days = var.observability_resources.prometheus.retention_days
      disk_gb        = var.disk_allocation.prometheus
    }
    grafana = {
      memory_limit = var.observability_resources.grafana.memory_limit
      disk_gb      = var.disk_allocation.grafana
    }
    zipkin = {
      memory_limit = var.observability_resources.zipkin.memory_limit
      jvm_heap     = "${var.observability_resources.zipkin.jvm_xms}-${var.observability_resources.zipkin.jvm_xmx}"
    }
    kibana = {
      memory_limit = var.observability_resources.kibana.memory_limit
    }
  }
}
