# ============================================================
# Módulo: Monitoring — Stack de Observabilidad (Helm en GKE)
# ============================================================
# Todos los recursos parametrizados desde var.observability_resources
# y var.disk_allocation (fuente única de verdad: Terraform).
# ============================================================

# ── Namespace ────────────────────────────────────────────────

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      environment = var.environment
      project     = "restaurant-pe"
    }
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PROMETHEUS + GRAFANA (kube-prometheus-stack)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "helm_release" "prometheus_stack" {
  name       = "rpe-monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "65.1.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # ── Grafana ──────────────────────────────────────────────
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }

  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.persistence.size"
    value = "${var.disk_allocation.grafana}Gi"
  }

  set {
    name  = "grafana.resources.limits.memory"
    value = var.observability_resources.grafana.memory_limit
  }

  set {
    name  = "grafana.resources.requests.memory"
    value = "128Mi"
  }

  # ── Prometheus ───────────────────────────────────────────
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "${var.observability_resources.prometheus.retention_days}d"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "${var.disk_allocation.prometheus}Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.observability_resources.prometheus.memory_limit
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = "192Mi"
  }

  # Habilitar ServiceMonitor para los microservicios Spring Boot
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ELASTICSEARCH
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "helm_release" "elasticsearch" {
  name       = "rpe-elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "8.5.1"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "replicas"
    value = tostring(var.observability_resources.elasticsearch.replicas)
  }

  set {
    name  = "resources.requests.memory"
    value = var.observability_resources.elasticsearch.memory_request
  }

  set {
    name  = "resources.limits.memory"
    value = var.observability_resources.elasticsearch.memory_limit
  }

  set {
    name  = "resources.limits.cpu"
    value = var.observability_resources.elasticsearch.cpu_limit
  }

  set {
    name  = "esJavaOpts"
    value = "-Xms${var.observability_resources.elasticsearch.heap_mb}m -Xmx${var.observability_resources.elasticsearch.heap_mb}m"
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = "${var.disk_allocation.elasticsearch}Gi"
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# KIBANA
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "helm_release" "kibana" {
  name       = "rpe-kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = "8.5.1"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "resources.limits.memory"
    value = var.observability_resources.kibana.memory_limit
  }

  set {
    name  = "resources.requests.memory"
    value = "192Mi"
  }

  depends_on = [helm_release.elasticsearch]
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ZIPKIN (tracing distribuido)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "helm_release" "zipkin" {
  name       = "rpe-zipkin"
  repository = "https://openzipkin.github.io/zipkin"
  chart      = "zipkin"
  version    = "0.4.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = var.observability_resources.zipkin.memory_limit
  }

  set {
    name  = "env.JAVA_OPTS"
    value = "-Xms${var.observability_resources.zipkin.jvm_xms} -Xmx${var.observability_resources.zipkin.jvm_xmx}"
  }
}
