# Postman — ms-ventas

Importar en Postman:

| Colección | Contenido |
|-----------|-----------|
| `ms-ventas.postman_collection.json` | Todos los endpoints `/api/ventas` por dominio. |
| `ms-ventas-fase4-ov-proforma-cierre-descuentos.postman_collection.json` | Subconjunto **Fase 4**: OV, proforma, cierre de caja, descuentos/promoción y seed admin (con cuerpos de ejemplo). |

Las carpetas por dominio (Zonas, Comandas, …) están agrupadas dentro de **Endpoints ms-ventas (/api/ventas)** en la colección completa.

**Variables de colección**

| Variable       | Uso                                      |
|----------------|------------------------------------------|
| `baseUrl`      | Ej. `http://localhost:9010`              |
| `accessToken`  | JWT (la colección usa Bearer auth)       |
| `*Id`          | IDs de ejemplo; reemplazar tras listar |

Las colecciones viven en este repo (`*.postman_collection.json`). Si cambian rutas o DTOs en ms-ventas, actualizar el JSON aquí o reexportar desde Postman para mantener contrato y ejemplos al día.
