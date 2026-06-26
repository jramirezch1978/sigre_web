# Flujos de Integración - ms-produccion

## Mapa de Integraciones

```
                    ┌──────────────────┐
                    │  ms-auth-security │
                    │  (JWT + tenant)   │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  ms-produccion   │
                    │    (:9009)       │
                    └───┬───┬───┬──────┘
                        │   │   │
              ┌─────────┘   │   └──────────┐
              ▼             ▼              ▼
   ┌──────────────────┐ ┌──────────┐ ┌──────────┐
   │ ms-core-maestros │ │ ms-almacen│ │ms-compras│
   │ (artículos,      │ │ (vales de │ │ (OCs,    │
   │  sucursales)     │ │movimiento)│ │ servicios)│
   └──────────────────┘ └──────────┘ └──────────┘
```

## Integraciones Actuales

### 1. Seguridad y Multi-tenancy (ms-auth-security)

- **Validación JWT**: El filtro `ProduccionJwtAuthenticationFilter` hereda de `JwtTenantAuthFilter` (common) y resuelve el tenant desde el token definitivo.
- **Validación sesiones**: `TokensSessionVerifier` consulta `auth.tokens_session` vía JDBC directo al datasource `restaurant_pe_security`.
- **Validación usuarios**: `OtAdministracionServiceImpl.asignarUsuario()` verifica existencia del usuario en `auth.usuario` mediante query nativa.

### 2. Core Maestros (ms-core-maestros)

- **Validación artículos**: `LaborServiceImpl.asignarInsumo()` y `asignarProducido()` verifican existencia del artículo en `core.articulo` mediante JDBC directo.
- **Referencias a sucursal**: `orden_trabajo`, `programacion_produccion` validan vía JDBC contra `auth.sucursal`.

## Integraciones Planificadas

### 3. Almacén (ms-almacen) — Consumo de Insumos

```
produccion.parte_produccion_insumo.cantidad
                    │
                    ▼
almacen.vale_mov (tipo_referencia_origen = 'P')
                    │
                    ▼
           descuento de stock
```

- Cuando se registra un parte de producción, se debe generar automáticamente un vale de movimiento en `ms-almacen` de tipo salida por producción.
- `almacen.vale_mov.tipo_referencia_origen = 'P'` identifica movimientos originados en producción.
- `almacen.vale_mov.orden_trabajo_id` vincula el vale a la OT correspondiente (ya existe como FK en el DDL de almacén).

### 4. Compras (ms-compras) — Requerimientos de Materiales

```
produccion.operaciones_det
                    │
                    ▼
compras.orden_compra_det.operaciones_det_id
compras.orden_servicio_det.operaciones_det_id
```

- Los requerimientos de materiales de una OT (`operaciones_det`) pueden originar órdenes de compra o servicios en `ms-compras`.
- La FK `operaciones_det_id` en las tablas de compras vincula la compra con la necesidad de producción.

### 5. Almacén (ms-almacen) — Actualización de costos de ingresos de producción

```
produccion.costeo_produccion (proceso batch mensual)
                    │
                    ▼
        costo_unitario calculado por OT / artículo producido
                    │
                    ▼
        [evento RabbitMQ] produccion.costeo.completado
                    │
                    ▼
          ms-almacen (actualizar ingresos de producción del mes)
                    │
                    ▼
   vale_mov / kardex de IN (tipo_referencia_origen = 'P')
   con costo unitario y valorización del periodo
                    │
                    ▼
        [evento RabbitMQ] almacen.movimiento.confirmado
                    │
                    ▼
          ms-contabilidad (asientos de almacén)
```

- **ms-produccion NO genera asientos contables de costeo.** Su responsabilidad termina en calcular el costo real del periodo.
- Al completar el costeo mensual, **ms-almacen** debe actualizar **todos los ingresos de producción del mes** de cada artículo afectado (movimientos de entrada originados en producción), aplicando el `costo_unitario` resultante del batch.
- La contabilización sigue el flujo estándar de almacén: cuando los movimientos quedan confirmados/valorizados, **ms-almacen** publica el evento que consume **ms-contabilidad** para generar los asientos (incluye compras, ventas, producción y demás movimientos de inventario).
- Separación de responsabilidades:
  - **ms-produccion:** cálculo de costos (MP + MO + CI) por periodo.
  - **ms-almacen:** stock, kardex, costo unitario de movimientos y emisión de eventos contables de inventario.
  - **ms-contabilidad:** asientos automáticos a partir de eventos de módulos operativos (no recibe costeo directo desde producción).
- **Implementado (productor ms-produccion):** `RabbitProduccionEventPublisher` en `POST /costeos/procesar` publica `produccion.costeo.completado` y `produccion.costeada`.
- **Implementado (consumer ms-almacen):** `ProduccionCosteoEventListener` actualiza vales tipo `P` del periodo costeado.

### 6. Auditoría (ms-auditoria) — Eventos de Producción

```
produccion (eventos: completada, cancelada, costeada)
                    │
                    ▼
        [evento RabbitMQ] produccion.*
                    │
                    ▼
            ms-auditoria
```

- Eventos: `produccion.completada` (OT cerrada), `produccion.cancelada` (OT anulada), `produccion.costeada` (tras batch).
- **Implementado (productor):** `POST /ordenes-trabajo/{id}/cerrar` y `POST /ordenes-trabajo/{id}/anular`.

## Dependencias entre Módulos

| Módulo | Dependencia | Tipo |
|---|---|---|
| ms-produccion → ms-core-maestros | Obtener artículos, sucursales | JDBC directo (actual) / OpenFeign (futuro) |
| ms-produccion → ms-auth-security | Validar JWT, sesiones, usuarios | JDBC directo + JWT filter |
| ms-produccion → ms-almacen | Consumir stock al registrar parte de producción (salidas) | Evento / Feign (planificado) |
| ms-produccion → ms-almacen | Actualizar costo de ingresos de producción del mes tras costeo batch | Evento RabbitMQ `produccion.costeo.completado` ✅ consumer en ms-almacen |
| ms-almacen → ms-contabilidad | Generar asientos de movimientos de inventario (incl. producción valorizada) | Evento RabbitMQ `movimiento.confirmado` (existente) |
| ms-compras → ms-produccion | Vincular OCs a requerimientos de OT | FK en BD (existente) |
| ms-almacen → ms-produccion | Vincular vales de movimiento a OT | FK en BD (existente) |
| ms-produccion → ms-auditoria | Enviar eventos de auditoría | Evento RabbitMQ ✅ productor |

## Patrón de Comunicación

| Tipo | Estado | Componente |
|---|---|---|
| JDBC directo (misma BD, distinto schema) | ✅ Actual | Validación OT, sucursal, centros costo |
| Filtro JWT (common) | ✅ Actual | Autenticación multi-tenant |
| OpenFeign | ✅ Activo | Sucursal, artículo, UM, vales (según servicio) |
| RabbitMQ/AMQP (productor) | ✅ Implementado | `event/publisher`, exchange `rpe.events` |

## Notas Técnicas

- **Datasource separado**: La conexión a `restaurant_pe_security` se configura aparte con su propio pool (max 3 conexiones) y SSL requerido.
- **Las validaciones de referencias externas** usan Feign y/o SQL nativo según el servicio.
- **Mensajería:** desactivar localmente con `APP_MESSAGING_ENABLED=false` si no hay broker.
- Los consumidores (`ms-contabilidad`, `ms-auditoria`) deben suscribirse a `rpe.events`.
