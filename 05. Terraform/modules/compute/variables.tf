# ============================================================
# Módulo: Compute — Variables
# ============================================================

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  description = "Zona de GCP para la instancia"
  type        = string
  default     = "us-east1-b"
}

variable "environment" {
  type = string
}

variable "network_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred"
  type        = string
}

variable "server_spec" {
  description = "Especificaciones del servidor"
  type = object({
    ram_gb    = number
    cpu_cores = number
    disk_gb   = number
  })
}

variable "ssh_public_key" {
  description = "Clave pública SSH para acceso al servidor"
  type        = string
  default     = ""
}
