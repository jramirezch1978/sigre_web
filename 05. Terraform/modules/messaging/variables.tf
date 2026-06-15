# ============================================================
# Módulo: Messaging — Variables
# ============================================================

variable "environment" {
  type = string
}

variable "rabbitmq_user" {
  type = string
}

variable "rabbitmq_pass" {
  type      = string
  sensitive = true
}

variable "rabbitmq_resources" {
  description = "Recursos para RabbitMQ (fuente: Terraform variables)"
  type = object({
    memory_limit   = string
    memory_request = string
    cpu_limit      = string
    cpu_request    = string
    replicas       = number
  })
}

variable "disk_gb" {
  description = "Disco para persistencia de RabbitMQ (GB)"
  type        = number
  default     = 10
}
