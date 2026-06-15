# ============================================================
# Módulo: Messaging — RabbitMQ (Helm en GKE)
# ============================================================
# Recursos parametrizados desde var.rabbitmq_resources
# (fuente única de verdad: Terraform variables/tfvars).
# ============================================================

resource "helm_release" "rabbitmq" {
  name       = "rpe-rabbitmq-${var.environment}"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = "14.7.0"
  namespace  = "messaging"

  create_namespace = true

  set {
    name  = "auth.username"
    value = var.rabbitmq_user
  }

  set_sensitive {
    name  = "auth.password"
    value = var.rabbitmq_pass
  }

  # ── Recursos parametrizados desde Terraform ──────────────
  set {
    name  = "resources.requests.memory"
    value = var.rabbitmq_resources.memory_request
  }

  set {
    name  = "resources.requests.cpu"
    value = var.rabbitmq_resources.cpu_request
  }

  set {
    name  = "resources.limits.memory"
    value = var.rabbitmq_resources.memory_limit
  }

  set {
    name  = "resources.limits.cpu"
    value = var.rabbitmq_resources.cpu_limit
  }

  # ── Réplicas y persistencia ──────────────────────────────
  set {
    name  = "replicaCount"
    value = tostring(var.rabbitmq_resources.replicas)
  }

  set {
    name  = "persistence.size"
    value = "${var.disk_gb}Gi"
  }

  # ── Plugins ──────────────────────────────────────────────
  set {
    name  = "plugins"
    value = "rabbitmq_management rabbitmq_shovel rabbitmq_shovel_management"
  }

  # ── Watermark (% de memoria para alertar) ────────────────
  set {
    name  = "memoryHighWatermark.enabled"
    value = "true"
  }

  set {
    name  = "memoryHighWatermark.type"
    value = "relative"
  }

  set {
    name  = "memoryHighWatermark.value"
    value = "0.4"
  }
}
