# ============================================================
# Módulo: Microservices — Variables
# ============================================================

variable "environment" {
  type = string
}

variable "project_id" {
  type = string
}

variable "services" {
  description = "Mapa de microservicios con su distribución de recursos"
  type = map(object({
    memory_limit   = string
    memory_request = string
    cpu_limit      = string
    cpu_request    = string
    jvm_xms        = string
    jvm_xmx        = string
    replicas       = number
    port           = number
    priority       = string
  }))
}

variable "container_registry" {
  description = "Registry de imágenes Docker (e.g. gcr.io/project-id)"
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Tag de la imagen Docker a desplegar"
  type        = string
  default     = "latest"
}

variable "eureka_uri" {
  description = "URI del servidor Eureka"
  type        = string
  default     = "http://eureka-server:8761/eureka"
}

variable "db_host" {
  description = "Host de PostgreSQL"
  type        = string
}

variable "db_port" {
  description = "Puerto de PostgreSQL"
  type        = number
  default     = 5432
}

variable "db_user" {
  description = "Usuario de PostgreSQL"
  type        = string
}

variable "db_password" {
  description = "Contraseña de PostgreSQL"
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "Host de Redis"
  type        = string
}

variable "redis_port" {
  description = "Puerto de Redis"
  type        = number
  default     = 6379
}

variable "redis_password" {
  description = "Contraseña de Redis"
  type        = string
  sensitive   = true
  default     = ""
}

variable "rabbitmq_host" {
  description = "Host de RabbitMQ"
  type        = string
  default     = "rabbitmq"
}

variable "rabbitmq_port" {
  description = "Puerto AMQP de RabbitMQ"
  type        = number
  default     = 5672
}

variable "rabbitmq_user" {
  description = "Usuario de RabbitMQ"
  type        = string
}

variable "rabbitmq_password" {
  description = "Contraseña de RabbitMQ"
  type        = string
  sensitive   = true
}
