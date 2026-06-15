# Credenciales GCP

Coloque aquí el archivo de credenciales del service account de GCP.

## Instrucciones

1. Ir a GCP Console → IAM → Service Accounts
2. Crear o seleccionar un service account con los roles necesarios:
   - `roles/cloudsql.admin`
   - `roles/compute.admin`
   - `roles/container.admin`
   - `roles/redis.admin`
   - `roles/storage.admin`
3. Generar una key JSON
4. Guardarla como `gcp-key.json` en esta carpeta

## Estructura esperada

```
credentials/
├── .gitignore      ← ignora todo excepto esto
├── README.md       ← este archivo
└── gcp-key.json    ← SU ARCHIVO (no se commitea)
```

## Seguridad

- Este directorio tiene `.gitignore` que excluye TODO excepto `.gitignore` y `README.md`
- **NUNCA** commitear archivos `.json` de credenciales
- En CI/CD, inyectar como variable de entorno o secret de GitLab
