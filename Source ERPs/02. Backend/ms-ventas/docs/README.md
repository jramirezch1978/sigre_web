# Documentación interna — `ms-ventas`

Material de apoyo para desarrollo y operación del microservicio. **No sustituye** los contratos y HU en `05. Documentacion/markdown/Contratos/ms-ventas/`.

---

## Documentos en la raíz del módulo (visión global)

| Documento | Contenido |
|-----------|-----------|
| [`../FLUJO_COMPLETO_MS_VENTAS.md`](../FLUJO_COMPLETO_MS_VENTAS.md) | Rol del MS, contexto técnico, flujos POS y CxC con diagramas. |
| [`../RESUMEN_LOGICA_Y_ENDPOINTS.md`](../RESUMEN_LOGICA_Y_ENDPOINTS.md) | Referencia rápida de endpoints por controlador. |
| [`../PROCESOS_VENTAS.md`](../PROCESOS_VENTAS.md) | Procesos multi-paso (POS, CxC + contabilidad, seed admin). |

---

## Índice de esta carpeta (`docs/`)

| Archivo | Tema |
|---------|------|
| [`openapi/README.md`](./openapi/README.md) | Export OpenAPI (Postman / clientes); script en `scripts/export-openapi-ms-ventas.bat`. |
| [`../postman/ms-ventas.postman_collection.json`](../postman/ms-ventas.postman_collection.json) | Colección Postman v2.1 (todos los endpoints `/api/ventas`). Ver [`../postman/README.md`](../postman/README.md). |
| [`../postman/ms-ventas-fase4-ov-proforma-cierre-descuentos.postman_collection.json`](../postman/ms-ventas-fase4-ov-proforma-cierre-descuentos.postman_collection.json) | Colección reducida Fase 4 (OV, proforma, cierre caja, promos, seed). |
| [`test-data-y-pruebas.md`](./test-data-y-pruebas.md) | Diferencia seed demo vs `VentasTestDataFactory` y smoke IT. |
| [`plan-implementacion.md`](./plan-implementacion.md) | Plan y estándares del microservicio. |
| [`VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md`](./VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md) | Divergencias y correcciones respecto al contrato. |
| [`endpoints-por-contrato.md`](./endpoints-por-contrato.md) | Mapeo explícito por contrato. |
| [`tablas-externas-requeridas.md`](./tablas-externas-requeridas.md) | FKs y datos esperados en otros esquemas. |
| [`diagrama-relaciones-ventas.md`](./diagrama-relaciones-ventas.md) | Relaciones del esquema `ventas`. |
| [`COMANDA_QUERY_ERROR_ANALYSIS.md`](./COMANDA_QUERY_ERROR_ANALYSIS.md) | Análisis puntual de consultas comanda. |
| [`vscode-launch-config.md`](./vscode-launch-config.md) | Sugerencias de launch/debug en VS Code. |
| [`faltante_20260502_ms_ventas.md`](./faltante_20260502_ms_ventas.md) | Informe histórico 2026-05-02; ver aviso de vigencia y enlaces a §14 orquestación / §5.2 faltantes. |
