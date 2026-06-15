# ============================================================
# Módulo: Microservices — K8s Deployments + Services
# ============================================================
# Despliega los 16 microservicios Spring Boot en GKE usando
# for_each sobre el mapa de resources definido en tfvars.
#
# Recursos de RAM, CPU y JVM heap provienen de Terraform
# variables (fuente única de verdad).
# ============================================================

# ── Namespace ────────────────────────────────────────────────

resource "kubernetes_namespace" "app" {
  metadata {
    name = "rpe-${var.environment}"
    labels = {
      environment = var.environment
      project     = "restaurant-pe"
      managed-by  = "terraform"
    }
  }
}

# ── Clasificación de servicios ───────────────────────────────

locals {
  # Servicios que NO requieren base de datos
  no_db_services = toset(["ms-reportes", "ms-notificaciones"])

  # Servicios que NO requieren RabbitMQ
  no_rabbit_services = toset(["eureka-server", "config-server", "api-gateway", "ms-auth-security"])

  # Servicios que requieren Redis
  redis_services = toset(["api-gateway", "ms-auth-security"])

  # Registry prefix
  image_prefix = var.container_registry != "" ? "${var.container_registry}/" : "rpe-"
}

# ── Resource Quota por namespace ─────────────────────────────

resource "kubernetes_resource_quota" "app" {
  metadata {
    name      = "rpe-quota-${var.environment}"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "8"
      "requests.memory" = "16Gi"
      "limits.cpu"      = "12"
      "limits.memory"   = "16Gi"
      "pods"            = "50"
    }
  }
}

# ── Secrets compartidos ──────────────────────────────────────

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "rpe-db-credentials"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    DB_HOST     = var.db_host
    DB_PORT     = tostring(var.db_port)
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
  }
}

resource "kubernetes_secret" "redis_credentials" {
  metadata {
    name      = "rpe-redis-credentials"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    REDIS_HOST     = var.redis_host
    REDIS_PORT     = tostring(var.redis_port)
    REDIS_PASSWORD = var.redis_password
  }
}

resource "kubernetes_secret" "rabbit_credentials" {
  metadata {
    name      = "rpe-rabbit-credentials"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    RABBIT_HOST = var.rabbitmq_host
    RABBIT_PORT = tostring(var.rabbitmq_port)
    RABBIT_USER = var.rabbitmq_user
    RABBIT_PASS = var.rabbitmq_password
  }
}

# ── ConfigMap compartido ─────────────────────────────────────

resource "kubernetes_config_map" "shared" {
  metadata {
    name      = "rpe-shared-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    EUREKA_URI  = var.eureka_uri
    ENVIRONMENT = var.environment
    TZ          = "America/Lima"
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DEPLOYMENTS — uno por microservicio (for_each)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "kubernetes_deployment" "service" {
  for_each = var.services

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app         = each.key
      environment = var.environment
      priority    = each.value.priority
      managed-by  = "terraform"
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.key
      }
    }

    # Estrategia de despliegue
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = each.value.priority == "critical" ? "0" : "1"
        max_surge       = "1"
      }
    }

    template {
      metadata {
        labels = {
          app         = each.key
          environment = var.environment
          priority    = each.value.priority
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/actuator/prometheus"
          "prometheus.io/port"   = tostring(each.value.port)
        }
      }

      spec {
        # Afinidad: preferir nodos diferentes para servicios críticos
        dynamic "affinity" {
          for_each = each.value.priority == "critical" ? [1] : []
          content {
            pod_anti_affinity {
              preferred_during_scheduling_ignored_during_execution {
                weight = 100
                pod_affinity_term {
                  label_selector {
                    match_expressions {
                      key      = "app"
                      operator = "In"
                      values   = [each.key]
                    }
                  }
                  topology_key = "kubernetes.io/hostname"
                }
              }
            }
          }
        }

        container {
          name  = each.key
          image = "${local.image_prefix}${each.key}:${var.image_tag}"

          port {
            container_port = each.value.port
            name           = "http"
          }

          # ── Recursos (FUENTE: variables de Terraform) ────
          resources {
            limits = {
              memory = each.value.memory_limit
              cpu    = each.value.cpu_limit
            }
            requests = {
              memory = each.value.memory_request
              cpu    = each.value.cpu_request
            }
          }

          # ── JVM Tuning ──────────────────────────────────
          env {
            name  = "JAVA_TOOL_OPTIONS"
            value = join(" ", [
              "-Xms${each.value.jvm_xms}",
              "-Xmx${each.value.jvm_xmx}",
              "-XX:+UseG1GC",
              "-XX:MaxGCPauseMillis=200",
              "-XX:+UseStringDeduplication",
              "-Djava.security.egd=file:/dev/./urandom",
            ])
          }

          # ── Config compartida ───────────────────────────
          env_from {
            config_map_ref {
              name = kubernetes_config_map.shared.metadata[0].name
            }
          }

          # ── Credenciales de BD (si aplica) ──────────────
          dynamic "env_from" {
            for_each = contains(local.no_db_services, each.key) ? [] : [1]
            content {
              secret_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
              }
            }
          }

          # ── Credenciales de Redis (si aplica) ───────────
          dynamic "env_from" {
            for_each = contains(local.redis_services, each.key) ? [1] : []
            content {
              secret_ref {
                name = kubernetes_secret.redis_credentials.metadata[0].name
              }
            }
          }

          # ── Credenciales de RabbitMQ (si aplica) ────────
          dynamic "env_from" {
            for_each = contains(local.no_rabbit_services, each.key) ? [] : [1]
            content {
              secret_ref {
                name = kubernetes_secret.rabbit_credentials.metadata[0].name
              }
            }
          }

          # ── Health checks ───────────────────────────────
          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = each.value.port
            }
            initial_delay_seconds = 60
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/actuator/health/readiness"
              port = each.value.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/actuator/health"
              port = each.value.port
            }
            initial_delay_seconds = 15
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 12 # 2 minutos máximo para arrancar
          }
        }

        # Graceful shutdown
        termination_grace_period_seconds = 30
      }
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].template[0].metadata[0].annotations["kubectl.kubernetes.io/restartedAt"],
    ]
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SERVICES — ClusterIP por microservicio (for_each)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "kubernetes_service" "service" {
  for_each = var.services

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app        = each.key
      managed-by = "terraform"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = tostring(each.value.port)
    }
  }

  spec {
    selector = {
      app = each.key
    }

    port {
      name        = "http"
      port        = each.value.port
      target_port = each.value.port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HORIZONTAL POD AUTOSCALER — solo servicios críticos/high
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "kubernetes_horizontal_pod_autoscaler_v2" "hpa" {
  for_each = {
    for name, svc in var.services : name => svc
    if contains(["critical", "high"], svc.priority) && var.environment != "dev"
  }

  metadata {
    name      = "${each.key}-hpa"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = each.key
    }

    min_replicas = each.value.replicas
    max_replicas = each.value.replicas * 3

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 75
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 85
        }
      }
    }
  }
}
