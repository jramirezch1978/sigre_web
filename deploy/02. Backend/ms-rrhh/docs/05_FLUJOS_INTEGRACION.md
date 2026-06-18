# Flujos de Integración — ms-rrhh

## Mapa de Integraciones

```
                        ┌──────────────────────┐
                        │   ms-auth-security    │
                        │  (JWT + tenant)       │
                        └──────────┬───────────┘
                                   │
                                   ▼
                        ┌──────────────────────┐
                        │     ms-rrhh (:9010)   │
                        └───┬───┬───┬───┬───┬──┘
                            │   │   │   │   │
              ┌─────────────┘   │   │   │   └──────────────┐
              ▼                 ▼   ▼   ▼                  ▼
   ┌──────────────────┐  ┌──────────┐ ┌──────────┐ ┌──────────┐
   │ ms-core-maestros │  │ms-finanzas│ │ms-contab. │ │ ms-ventas│
   │ (entidad_contrib,│  │(cntas x  │ │(asientos  │ │ (propinas│
   │  tipo_doc_id)    │  │  pagar)  │ │ provisión)│ │  comisión)│
   └──────────────────┘  └──────────┘ └──────────┘ └──────────┘
                                   │
                                   ▼
                        ┌──────────────────────┐
                        │  ms-almacen           │
                        │  (vales de consumo)   │
                        └──────────────────────┘
```

---

## Integraciones Actuales

### 1. Seguridad y Multi-tenancy (ms-auth-security)

| Aspecto | Detalle |
|---------|---------|
| **Tipo** | JWT Filter (módulo common) |
| **Validación** | Filtro `JwtTenantAuthFilter` valida token y resuelve tenant |
| **Sucursal** | Validación de sucursal vía JDBC directo a esquema `auth` |
| **Estado** | ✅ Implementado |

### 2. Core Maestros (ms-core-maestros)

| Aspecto | Detalle |
|---------|---------|
| **Tipo** | OpenFeign client |
| **Validaciones** | `entidad_contribuyente` y `tipo_doc_identidad` en trabajador |
| **Estado** | ✅ Implementado |

### 3. Finanzas (ms-finanzas) — FK diferida

| Aspecto | Detalle |
|---------|---------|
| **Tipo** | DDL (FK en esquema `finanzas`) |
| **Enlace** | `finanzas.cntas_pagar_det.trabajador_id → rrhh.trabajador(id)` |
| **Propósito** | Pagos de nómina, aportes, retenciones |
| **Estado** | ✅ Implementado (FK en DDL) |

---

## Integraciones Planificadas

### 4. Contabilidad (ms-contabilidad) — Asientos de Provisión

| Evento | Descripción | Estado |
|--------|-------------|:------:|
| Cálculo de planilla mensual | Generar asiento contable automático de gastos de personal | ❌ |
| Gratificación batch | Asiento de provisión semestral | ❌ |
| CTS batch | Asiento de provisión semestral | ❌ |
| Liquidación | Asiento de cese del trabajador | ❌ |
| Provisión de gasto | Configuración de reglas contables por tipo de gasto | ❌ |

### 5. Almacén (ms-almacen) — Vales de Consumo

| Aspecto | Detalle |
|---------|---------|
| **Propósito** | Descuento automático de vales de consumo a trabajadores |
| **Tipo** | Evento RabbitMQ o Feign |
| **Estado** | ❌ Pendiente |

### 6. Ventas/POS (ms-ventas) — Propinas y Comisiones

| Aspecto | Detalle |
|---------|---------|
| **Propósito** | Distribución automática de propinas y recargo al consumo en nómina |
| **Integración** | Las variables de propinas alimentan `gan_desct_variable` |
| **Estado** | ❌ Pendiente |

### 7. BI/Reportes — Dashboards

| Aspecto | Detalle |
|---------|---------|
| **Propósito** | Dashboard de indicadores: costo laboral/venta, % propinas, HE, rotación, headcount |
| **Estado** | ❌ Pendiente |

### 8. Sistema de Asistencia Biométrico

| Aspecto | Detalle |
|---------|---------|
| **Propósito** | Importación automática de marcaciones desde dispositivos biométricos |
| **Tipo** | API REST o archivo plano |
| **Estado** | ❌ Pendiente |

---

## Dependencias entre Módulos

| Módulo | Dependencia | Tipo | Estado |
|--------|-------------|------|:------:|
| ms-rrhh → ms-auth-security | Validar JWT, resolver tenant | JWT Filter | ✅ |
| ms-rrhh → ms-core-maestros | Validar entidad contribuyente | Feign | ✅ |
| ms-rrhh → ms-core-maestros | Validar tipo doc identidad | Feign | ✅ |
| ms-rrhh → ms-finanzas | FK cntas_pagar_det → trabajador | DDL | ✅ |
| ms-rrhh → ms-contabilidad | Asientos provisión planilla | Evento | ❌ |
| ms-rrhh → ms-ventas | Propinas/recargo a nómina | Evento | ❌ |
| ms-rrhh → ms-almacen | Vales de consumo descuento | Evento | ❌ |
| ms-rrhh → BI | Dashboards indicadores | Consulta | ❌ |

---

## Patrón de Comunicación

| Tipo | Estado | Componente | Uso |
|------|:------:|------------|-----|
| JDBC directo | ✅ | Conexión a esquema `auth` | Validación sucursal, usuario |
| JWT Filter (common) | ✅ | `JwtTenantAuthFilter` | Autenticación multi-tenant |
| OpenFeign | ✅ | `CoreMaestrosClient` | Validación entidad contribuyente, tipo doc |
| OpenFeign | ✅ | `AuthClient` | Validación usuarios |
| RabbitMQ/AMQP | ❌ | Event publishers | Notificar cálculo completado, gratificación, CTS |
| API REST | ❌ | Endpoints expuestos | Integración con biométrico, BI |

---

## Patrón de Procesos Batch

Todos los procesos batch siguen este flujo de integración:

```
POST /api/rrhh/{recurso}/procesar
  → validar período/tipo (unicidad, no cerrado)
  → buscar trabajadores activos con derecho
  → calcular por trabajador (lógica de negocio específica)
  → guardar/actualizar en BD (idempotente)
  → publicar evento RabbitMQ (planificado)
  → retornar resumen del proceso
```

Aplica a:
- Cálculo de Planilla (`/calculos/procesar`)
- Gratificación (`/gratificaciones/procesar`)
- CTS (`/cts/procesar`)
- Liquidación (POST `/liquidaciones`)

---

## Eventos RabbitMQ Planificados

| Evento | Disparador | Contenido |
|--------|-----------|-----------|
| `CalculoCompletadoEvent` | POST /calculos/procesar | `{ calculoId, anio, mes, tipoPlanilla, totalNeto, tenantId }` |
| `GratificacionCompletadaEvent` | POST /gratificaciones/procesar | `{ periodoGratificacionId, anio, total, tenantId }` |
| `CtsCompletadaEvent` | POST /cts/procesar | `{ periodoCtsId, anio, total, tenantId }` |
| `LiquidacionAprobadaEvent` | POST /liquidaciones/{id}/aprobar | `{ liquidacionId, trabajadorId, netoPagar, tenantId }` |

---

## FK Diferida — finanzas

```sql
-- En DDL: finanzas.cntas_pagar_det → rrhh.trabajador
ALTER TABLE finanzas.cntas_pagar_det
  ADD CONSTRAINT fk_cpd_trabajador
  FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id);
```

Esta FK permite que `ms-finanzas` genere cuentas por pagar a trabajadores
(liquidaciones, haberes, etc.) referenciando directamente al trabajador en `rrhh`.
