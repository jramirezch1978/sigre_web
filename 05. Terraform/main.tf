# ============================================================
# SIGRE ERP — Terraform Root Module
# ============================================================
# Modo principal: generar docker-compose para servidor cronos
#   terraform init
#   terraform apply -var-file="environments/cronos.tfvars"
#
# Modo GCP (legacy): deployment_target = "gcp"
# ============================================================

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  is_docker_compose = var.deployment_target == "docker-compose"
  is_gcp            = var.deployment_target == "gcp"

  common_labels = {
    project     = "sigre-erp"
    environment = var.environment
    managed-by  = "terraform"
  }

  enabled_microservices = {
    for name, svc in var.microservice_resources : name => svc if svc.enabled
  }

  app_memory_mb = sum([
    for name, svc in local.enabled_microservices : tonumber(replace(svc.memory_limit, "Mi", ""))
  ])

  frontend_memory_mb = tonumber(replace(var.frontend_resources.memory_limit, "Mi", ""))

  postgres_memory_mb = tonumber(replace(var.postgres_resources.memory_limit, "Mi", ""))

  sonarqube_memory_mb = var.testing_resources.sonarqube.enabled ? tonumber(replace(var.testing_resources.sonarqube.memory_limit, "Mi", "")) : 0

  total_app_stack_mb = local.app_memory_mb + local.frontend_memory_mb + local.postgres_memory_mb

  api_public_url = "http://${var.docker_stack.public_host}:${var.service_ports.api_gateway}"
  frontend_public_url = "http://${var.docker_stack.public_host}:${var.service_ports.frontend}"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GCP (legacy) — solo si deployment_target = gcp
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

module "networking" {
  source = "./modules/networking"
  count  = local.is_gcp ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
}

module "compute" {
  source = "./modules/compute"
  count  = local.is_gcp && var.environment == "dev" ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  network_id  = module.networking[0].vpc_id
  subnet_id   = module.networking[0].subnet_id
  server_spec = {
    ram_gb    = var.server_spec.ram_gb
    cpu_cores = var.server_spec.cpu_cores
    disk_gb   = var.server_spec.disk_gb
  }

  depends_on = [module.networking]
}

module "database" {
  source = "./modules/database"
  count  = local.is_gcp ? 1 : 0

  project_id        = var.project_id
  region            = var.region
  environment       = var.environment
  network_id        = module.networking[0].vpc_id
  db_tier           = var.db_tier
  db_disk_size      = var.db_disk_size
  db_admin_password = var.db_admin_password
  pg_tuning         = var.pg_tuning

  depends_on = [module.networking]
}

module "kubernetes" {
  source = "./modules/kubernetes"
  count  = local.is_gcp && var.environment != "dev" ? 1 : 0

  project_id     = var.project_id
  region         = var.region
  environment    = var.environment
  network_id     = module.networking[0].vpc_id
  subnet_id      = module.networking[0].subnet_id
  node_count     = var.gke_node_count
  machine_type   = var.gke_machine_type
  min_node_count = var.gke_min_nodes
  max_node_count = var.gke_max_nodes

  depends_on = [module.networking]
}

module "redis" {
  source = "./modules/redis"
  count  = local.is_gcp ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  network_id  = module.networking[0].vpc_id
  memory_size = var.redis_resources.memory_gb

  depends_on = [module.networking]
}

module "messaging" {
  source = "./modules/messaging"
  count  = local.is_gcp && var.environment != "dev" ? 1 : 0

  environment        = var.environment
  rabbitmq_user      = var.rabbitmq_user
  rabbitmq_pass      = var.rabbitmq_pass
  rabbitmq_resources = var.rabbitmq_resources
  disk_gb            = 10

  depends_on = [module.kubernetes]
}

module "storage" {
  source = "./modules/storage"
  count  = local.is_gcp ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
}

module "monitoring" {
  source = "./modules/monitoring"
  count  = local.is_gcp && var.environment != "dev" ? 1 : 0

  environment             = var.environment
  grafana_password        = var.grafana_password
  observability_resources = var.observability_resources
  disk_allocation = {
    elasticsearch = 50
    prometheus    = 20
    grafana       = 2
  }

  depends_on = [module.kubernetes]
}

module "microservices" {
  source = "./modules/microservices"
  count  = local.is_gcp && var.environment != "dev" ? 1 : 0

  environment        = var.environment
  project_id         = var.project_id
  services           = var.microservice_resources
  container_registry = "gcr.io/${var.project_id}"
  db_host            = module.database[0].private_ip
  db_user            = "sigre_admin"
  db_password        = var.db_admin_password
  redis_host         = module.redis[0].host
  redis_password     = ""
  rabbitmq_user      = var.rabbitmq_user
  rabbitmq_password  = var.rabbitmq_pass

  depends_on = [module.kubernetes, module.database, module.redis]
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CRONOS — Docker Compose generado (infra + app)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "local_file" "docker_compose_stack" {
  count    = local.is_docker_compose && var.generate_docker_compose ? 1 : 0
  filename = "${var.docker_compose_output_dir}/docker-compose.stack.yml"

  content = templatefile("${path.module}/templates/docker-compose.stack.yml.tftpl", {
    environment         = var.environment
    server_spec         = var.server_spec
    docker_stack        = var.docker_stack
    service_ports       = var.service_ports
    postgres_config     = var.postgres_config
    postgres_resources  = var.postgres_resources
    pg_tuning           = var.pg_tuning
    testing_resources   = var.testing_resources
    disk_allocation     = var.disk_allocation
    postgres_password   = var.db_admin_password
    erp_app_password    = var.erp_app_password
    timezone            = var.docker_stack.timezone
  })
}

resource "local_file" "docker_compose_app" {
  count    = local.is_docker_compose && var.generate_docker_compose ? 1 : 0
  filename = "${var.docker_compose_output_dir}/docker-compose.app.yml"

  content = templatefile("${path.module}/templates/docker-compose.app.yml.tftpl", {
    environment           = var.environment
    docker_stack          = var.docker_stack
    service_ports         = var.service_ports
    image_registry        = var.image_registry
    image_tag             = var.image_tag
    use_prebuilt_images   = var.use_prebuilt_images
    microservices         = local.enabled_microservices
    frontend              = var.frontend_resources
    postgres_service_name = var.postgres_config.service_name
    api_public_url        = local.api_public_url
    timezone              = var.docker_stack.timezone
    repo_dir              = var.docker_stack.repo_dir
  })
}

resource "local_file" "env_file" {
  count    = local.is_docker_compose && var.generate_docker_compose ? 1 : 0
  filename = "${var.docker_compose_output_dir}/.env.example"

  content = templatefile("${path.module}/templates/env.example.tftpl", {
    postgres_password   = var.db_admin_password
    erp_app_password    = var.erp_app_password
    postgres_superuser  = var.postgres_config.superuser
    postgres_service    = var.postgres_config.service_name
    public_host         = var.docker_stack.public_host
    api_gateway_port    = var.service_ports.api_gateway
    frontend_port       = var.service_ports.frontend
    timezone            = var.docker_stack.timezone
    image_registry      = var.image_registry
    image_tag           = var.image_tag
  })
}

resource "local_file" "deploy_script" {
  count    = local.is_docker_compose && var.generate_docker_compose ? 1 : 0
  filename = "${var.docker_compose_output_dir}/deploy.bat"

  content = templatefile("${path.module}/templates/deploy.bat.tftpl", {
    docker_context = var.docker_stack.docker_context
    stack_dir      = var.docker_stack.stack_dir
    repo_dir       = var.docker_stack.repo_dir
    public_host    = var.docker_stack.public_host
    frontend_port  = var.service_ports.frontend
    gateway_port   = var.service_ports.api_gateway
    sonarqube_port = var.service_ports.sonarqube
  })
}

resource "local_file" "postgres_init" {
  count    = local.is_docker_compose && var.generate_docker_compose ? 1 : 0
  filename = "${var.docker_compose_output_dir}/init/01-create-databases.sql"

  content = templatefile("${path.module}/templates/init-databases.sql.tftpl", {
    databases        = var.postgres_config.databases
    erp_app_password = var.erp_app_password
  })
}
