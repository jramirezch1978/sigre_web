# Export OpenAPI — `ms-ventas`

Aquí van los artefactos **OpenAPI 3** exportados desde SpringDoc (misma especificación que alimenta Swagger UI). Sirven para **Postman**, **Insomnia**, **Bruno**, generadores de cliente, etc.

## Cómo generar los archivos

1. Arranque `ms-ventas` (puerto por defecto **9010**).
2. Ejecute el exportador (ruta completa ejemplo en Windows):

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend\ms-ventas
.\scripts\export-openapi-ms-ventas.bat
```

Si el servicio escucha en otra URL:

```bat
set MS_VENTAS_OPENAPI_URL=http://127.0.0.1:9010
.\scripts\export-openapi-ms-ventas.bat
```

## Salida

| Archivo | Uso típico |
|---------|------------|
| `ms-ventas-openapi.json` | Import en Postman / codegen |
| `ms-ventas-openapi.yaml` | Misma spec en YAML (si SpringDoc la expone en su ruta `.yaml`) |

## Endpoints de SpringDoc en runtime

| Recurso | Ruta |
|---------|------|
| Documento JSON | `GET /api/ventas/v3/api-docs` |
| Documento YAML | `GET /api/ventas/v3/api-docs.yaml` |
| Swagger UI | `GET /api/ventas/swagger-ui.html` |

## Notas

- La spec incluye la ruta `POST /api/ventas/admin/test-data/seed` siempre; en runtime responde **403** `TESTDATA_DISABLED` si `app.testdata.enabled` es falso (por defecto en YAML suele estar **habilitado** vía `APP_TESTDATA_ENABLED`; en prod debe forzarse `false`).
- Los endpoints bajo `/api/ventas/**` suelen requerir **JWT** en entorno real; la spec puede declarar seguridad según la configuración global de SpringDoc/Spring Security.
