variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "network_id" {
  type = string
}

variable "memory_size" {
  description = "Tamaño de memoria Redis (GB)"
  type        = number
  default     = 1
}
