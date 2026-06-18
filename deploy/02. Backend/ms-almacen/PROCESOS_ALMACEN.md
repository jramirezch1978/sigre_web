# ms-almacen - Procesos operativos ALMACEN_PROC_*

Este documento deja explícita la implementación de los procesos operativos del bloque
"Procesos" para ambiente de prueba y operación controlada.

## Arquitectura elegida

- Se implementan como **endpoints de proceso** en `AlmacenProcesoController`.
- La ejecución es **sincrónica y transaccional** por request HTTP.
- No se creó job programado ni cola para esta primera etapa operativa.
- Los procesos quedan preparados para evolucionar a ejecución asíncrona si se requiere.

## Menú / endpoint / código

- `ALMACEN_PROC_RECALCULO`
  - `POST /api/almacen/procesos/recalculo-precios-promedio`
- `ALMACEN_PROC_CUADRE_STOCK`
  - `POST /api/almacen/procesos/cuadre-stock`
- `ALMACEN_PROC_ACT_AUTO`
  - `POST /api/almacen/procesos/actualizacion-automatica`

Body opcional:

```json
{
  "almacenId": 1
}
```

## Validación de resultados

Cada proceso devuelve en `ProcesoAlmacenResponse`:

- `procesados`: filas efectivamente actualizadas.
- `registrosEsperados`: filas esperadas por validación previa.
- `validacionOk`: `true` cuando `procesados` coincide con la validación.
- `detalleValidacion`: detalle con métricas de control.
- `codigoMenu`: código de opción de menú ejecutada.

## Logs operativos

Se registran logs `INFO/WARN` en `AlmacenProcesoServiceImpl`:

- inicio del proceso,
- métricas de validación (evaluados/diferencias/actualizados),
- cierre correcto o con observaciones.

## Validación 3 vías (recepción OC)

En `POST` integración recepción OC (`IntegracionAlmacenServiceImpl`), si `app.almacen.integracion.validar-tres-vias=true` (default):

- Cruza cantidad **ordenada** (`cant_proyectada`), **facturada** (`cant_facturada`) y, si se envía `inventarioConteoId`, **conteo físico** (`cantidad_conteo_1`).
- Error de negocio `ALM-097` (`VALIDACION_TRES_VIAS`) si hay desvío fuera de tolerancia (`ALMACEN_TOLERANCIA_TRES_VIAS`).
- Desactivar por request: `validarTresVias=false` en `IntegracionRecepcionOcRequest`.

Valorización: el MS opera con **costo promedio** y kardex; PEPS/UEPS no están implementados en esta entrega.

## Notas de comportamiento

- `ALMACEN_PROC_RECALCULO` recalcula costo promedio con el último saldo valorizado disponible.
- `ALMACEN_PROC_CUADRE_STOCK` alinea stock desde posiciones e incluye artículos sin posiciones (stock 0).
- `ALMACEN_PROC_ACT_AUTO` ejecuta primero cuadre y luego recálculo, consolidando validación.

---

## Seed administrativo (demo masiva)

No es un proceso de menú batch; es un **endpoint admin** pensado para entornos controlados.

| Ítem | Detalle |
|------|---------|
| Endpoint | `POST /api/almacen/admin/test-data/seed` |
| Activación | Propiedad `app.testdata.enabled` (env **`APP_TESTDATA_ENABLED`**); por defecto orientado a **habilitado** en YAML local; **producción: desactivar**. |
| Registro del bean | Solo si el flag es `true`; si no, no existe la ruta (404). |
| Implementación | `TestDataSeedService` + `TestDataAdminController` |

Orquestación: [`../../05. Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md).
