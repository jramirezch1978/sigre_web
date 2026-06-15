# ============================================================
# Restaurant.pe ERP — Terraform Runner Container
# ============================================================
# Imagen con Terraform + gcloud SDK + herramientas auxiliares.
# Se ejecuta como contenedor dentro de Docker Compose.
#
# Uso desde docker-compose:
#   docker-compose exec terraform terraform plan
#   docker-compose exec terraform terraform apply
#   docker-compose exec terraform gcloud auth login
#
# Uso directo:
#   docker build -t rpe-terraform .
#   docker run -it -v $(pwd):/workspace rpe-terraform plan
# ============================================================

FROM hashicorp/terraform:1.9 AS terraform-base

# ── Stage 2: imagen final con gcloud + terraform ─────────────
FROM alpine:3.20

LABEL maintainer="SIGRE DevOps"
LABEL description="Terraform runner para IaC SIGRE ERP (cronos + GCP legacy)"

# ── Instalar dependencias base ───────────────────────────────
RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    python3 \
    py3-pip \
    openssh-client \
    ca-certificates \
    gnupg \
    docker-cli \
    make

# ── Copiar Terraform desde la imagen oficial ─────────────────
COPY --from=terraform-base /bin/terraform /usr/local/bin/terraform

# ── Instalar Google Cloud SDK ────────────────────────────────
ENV CLOUDSDK_INSTALL_DIR=/usr/lib
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- \
    --disable-prompts \
    --install-dir=${CLOUDSDK_INSTALL_DIR}

ENV PATH="${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin:${PATH}"

# ── Instalar kubectl (para módulo kubernetes) ────────────────
RUN gcloud components install kubectl --quiet 2>/dev/null || \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -f kubectl

# ── Instalar helm (para módulos que usan Helm provider) ─────
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ── Directorio de trabajo ────────────────────────────────────
WORKDIR /workspace

# ── Volúmenes esperados ──────────────────────────────────────
# /workspace         → configs de Terraform (montado)
# /workspace/.terraform → plugins (volumen persistente)
# /credentials       → credenciales GCP (montado)

# ── Variables de entorno por defecto ─────────────────────────
ENV TF_IN_AUTOMATION=true
ENV TF_CLI_ARGS_plan="-input=false"
ENV TF_CLI_ARGS_apply="-input=false"
ENV TF_PLUGIN_CACHE_DIR="/workspace/.terraform-plugin-cache"

# ── Script de entrada ────────────────────────────────────────
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["help"]
