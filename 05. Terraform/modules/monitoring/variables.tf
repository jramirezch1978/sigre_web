# ============================================================
# Módulo: Monitoring — Variables
# ============================================================

variable "environment" {
  type = string
}

variable "grafana_password" {
  type      = string
  sensitive = true
}

variable "observability_resources" {
  description = "Recursos para stack de observabilidad (fuente: Terraform variables)"
  type = object({
    elasticsearch = object({
      memory_limit   = string
      memory_request = string
      cpu_limit      = string
      heap_mb        = number
      replicas       = number
    })
    kibana = object({
      memory_limit = string
    })
    prometheus = object({
      memory_limit   = string
      retention_days = number
    })
    grafana = object({
      memory_limit = string
    })
    zipkin = object({
      memory_limit = string
      jvm_xms      = string
      jvm_xmx      = string
    })
  })
}

variable "disk_allocation" {
  description = "Asignación de disco para componentes de observabilidad"
  type = object({
    elasticsearch = number
    prometheus    = number
    grafana       = number
  })
}
