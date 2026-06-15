# SIGRE ERP — Despliegue cronos

Archivos generados/adaptados para el servidor **cronos** (`192.168.0.163`).

## Terraform — recrear stack idéntico a cronos

El stack de infraestructura (PostgreSQL 17 + SonarQube + init SQL) se define en **`05. Terraform/`** y se genera en `deploy/cronos/`:

```bash
cd "05. Terraform"
terraform init
terraform apply -var-file=environments/cronos.tfvars -var-file=secrets.tfvars
```

Salida regenerada:

| Archivo | Contenido |
|---------|-----------|
| `docker-compose.stack.yml` | PG17 (3g, tuning contexto.txt) + SonarQube (9001, perfil tools) |
| `init/01-create-databases.sql` | Roles `erp_app`, `sonarqube` + bases multitenant |
| `.env.example` | POSTGRES_PASSWORD, ERP_APP_PASSWORD, SONAR_DB_PASSWORD |

**Recrear en cronos** (volumen nuevo = init SQL automático):

```bat
.\server-manage.bat sync-compose
.\deploy.bat stack --force
.\database-deploy.bat create-security --force
.\database-deploy.bat create-template --force
.\database-deploy.bat clone cantabria --force
```

> `docker compose down -v` elimina `postgres_data`. Usar solo cuando quieras reconstruir desde cero.

## Arquitectura

| Archivo | Contenido | RAM aprox. |
|---------|-----------|------------|
| `docker-compose.stack.yml` | PG17 + SonarQube (perfil `tools`, restart no) | PG 3g, Sonar 3g bajo demanda |
| `docker-compose.app.yml` | Eureka + API Gateway + Asistencia + Frontend | ~1.7 GB |

Red Docker: **`stack_default`** — JDBC interno: `jdbc:postgresql://postgres:5432/...`

## Puertos NAT (crisaor.serveftp.com)

| Servicio | Puerto |
|----------|--------|
| Frontend | 8080 |
| API Gateway | 9080 |
| PostgreSQL | 5432 |
| SonarQube | **9001** (9001:9000) |

## PostgreSQL (contexto.txt)

- `shared_buffers=768MB`, `max_connections=100`, `mem_limit=3g`, `shm_size=256mb`
- Init: UTF8 / `en_US.utf8` / `America/Lima`
- Contraseñas en `.env` (no hardcodear en compose)

## Pools HikariCP (max_connections=100)

Backend desplegado: `asistencia-service` pool=5. Regla: `(N × 5) + 15 reserva ≤ 85`.

## Método de despliegue app

**Build local (Windows) → push GHCR → pull/up en cronos.**

```bat
.\build.bat backend
.\build.bat frontend
.\deploy.bat backend
.\deploy.bat frontend
```

## SonarQube bajo demanda

```bash
docker compose --profile tools up -d sonarqube   # http://crisaor.serveftp.com:9001
docker compose --profile tools stop sonarqube
```

## Checklist post-despliegue

- [ ] `curl http://crisaor.serveftp.com:9080/actuator/health`
- [ ] `curl http://crisaor.serveftp.com:8080`
- [ ] `docker exec postgres17 pg_isready -U postgres`
- [ ] Bases: `sigre_security`, `sigre_template`, `sigre_emp_cantabria`
- [ ] Eureka: `discovery-server` healthy
