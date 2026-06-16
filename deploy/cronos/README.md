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

| Archivo | Contenido |
|---------|-----------|
| `docker-compose.stack.yml` | PG17 + RabbitMQ + BD asistencia + SonarQube (perfil `tools`, restart no) |
| `docker-compose.app.yml` | Eureka + Gateway + microservicios + Frontend |

Red Docker compartida: **`stack_default`** (externa). La app y el stack se conectan a la misma red; Compose **no** intenta recrearla (`external: true`).

JDBC interno ERP: `jdbc:postgresql://postgres:5432/...`  
JDBC asistencia: `jdbc:postgresql://db-sigre-web:5432/db-sigre-web`

## Presupuesto RAM (VM 10 GB — contexto.txt)

Los `mem_limit` son techo cgroup; el heap JVM va en `JAVA_OPTS` (`-Xmx`). Dejar ~1,5 GB libres para SO + page cache.

### Stack (`docker-compose.stack.yml`)

| Servicio | mem_limit | Notas |
|----------|-----------|-------|
| postgres17 | 3g | `shared_buffers=768MB`, `max_connections=100` |
| rabbitmq | 384m | Mensajería Spring (health RabbitMQ) |
| db-sigre-web | 384m | Postgres dedicado asistencia (NAT **5433**) |
| sonarqube | 3g | Solo perfil `tools` — apagado en operación normal |
| **Subtotal stack** | **~3,8 GB** | Sin Sonar: ~3,8 GB |

### App (`docker-compose.app.yml`)

| Servicio | mem_limit | JAVA_OPTS (-Xmx) |
|----------|-----------|------------------|
| discovery-server | 384m | 192m |
| api-gateway | 384m | 192m |
| asistencia-service | 384m | 192m |
| seguridad-service | 448m | 320m |
| core, almacen, compras, contabilidad, finanzas, rrhh, produccion, comercializacion (×8) | 384m c/u | 192m c/u |
| sigre-frontend | 96m | — |
| **Subtotal app** | **~4,8 GB** | 14 contenedores |

### Totales operación normal (sin SonarQube)

| Capa | mem_limit sumado |
|------|------------------|
| Stack | ~3,8 GB |
| App | ~4,8 GB |
| **Total** | **~8,6 GB** (límite cgroup; uso real menor por heap compartido y servicios idle) |

> SonarQube bajo demanda suma ~3g adicionales. No levantarlo en cronos salvo análisis puntual.

## Puertos NAT (crisaor.serveftp.com)

| Servicio | Puerto |
|----------|--------|
| Frontend | 8080 |
| API Gateway | 9080 |
| PostgreSQL ERP | 5432 |
| PostgreSQL asistencia | 5433 |
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
.\deploy.bat backend --force
.\deploy.bat frontend --force
```

Stack infra (red externa — no bajar contenedores app):

```bat
.\deploy.bat stack --force
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
- [ ] `docker exec rabbitmq rabbitmq-diagnostics -q ping`
- [ ] Bases: `sigre_security`, `sigre_template`, `sigre_emp_cantabria`
- [ ] Eureka: `discovery-server` healthy
