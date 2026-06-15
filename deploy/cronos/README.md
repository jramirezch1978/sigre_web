# SIGRE ERP — Despliegue cronos

Archivos generados/adaptados para el servidor **cronos** (`192.168.0.163`).

## Arquitectura

| Archivo | Contenido | RAM aprox. |
|---------|-----------|------------|
| `docker-compose.stack.yml` | PostgreSQL 17 + SonarQube (perfil `tools`) | PG 2 GB, Sonar 1.5 GB bajo demanda |
| `docker-compose.app.yml` | Eureka + API Gateway + Asistencia + Frontend | ~1.7 GB |

Red Docker: **`stack_default`** — JDBC interno: `jdbc:postgresql://postgres:5432/...`

## Puertos NAT (crisaor.serveftp.com)

| Servicio | Puerto |
|----------|--------|
| Frontend | 8080 |
| API Gateway | 9080 |
| PostgreSQL | 5432 |
| SonarQube | 9000 |

## Si PostgreSQL ya está corriendo (postgres17)

No ejecutes `stack` si ya tienes el contenedor. Solo:

```bash
cp .env.example .env   # editar contraseñas
docker compose --env-file .env -f docker-compose.app.yml pull
docker compose --env-file .env -f docker-compose.app.yml up -d
```

## Despliegue completo (VM cronos)

```bash
cd /home/jramirez/stack
cp /home/jramirez/sigre_web/deploy/cronos/docker-compose.stack.yml .
cp /home/jramirez/sigre_web/deploy/cronos/docker-compose.app.yml .
cp -r /home/jramirez/sigre_web/deploy/cronos/init .
cp /home/jramirez/sigre_web/deploy/cronos/.env.example .env
nano .env

./deploy.sh stack    # solo si PG no existe aún
./deploy.sh app
./deploy.sh status
```

## SonarQube bajo demanda

```bash
./deploy.sh sonarqube-up
./deploy.sh sonarqube-down
```

## Regenerar con Terraform

```bash
cd "05. Terraform"
terraform init
terraform apply -var-file=environments/cronos.tfvars -var-file=secrets.tfvars
```

Salida en `deploy/cronos/`.

## Checklist post-despliegue

- [ ] `curl http://crisaor.serveftp.com:9080/actuator/health`
- [ ] `curl http://crisaor.serveftp.com:8080`
- [ ] `docker exec postgres17 pg_isready -U postgres`
- [ ] Bases creadas: `sigre_security`, `template_sigre`, `sonarqube`
- [ ] Eureka: contenedor `discovery-server` healthy
