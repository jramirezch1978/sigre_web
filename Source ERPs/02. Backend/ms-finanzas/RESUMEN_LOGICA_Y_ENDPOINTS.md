# `ms-finanzas` — resumen de lógica y endpoints

**Orquestación (secuencias por procedimiento + token):** [`05. Documentacion/orquestacion/ORQUESTACION_MS-FINANZAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-FINANZAS.md)  
**Catálogo de procesos:** [`05. Documentacion/orquestacion/CATALAGO_DE_PROCESOS_MS-FINANZAS.md`](../../05.%20Documentacion/orquestacion/CATALAGO_DE_PROCESOS_MS-FINANZAS.md)

Este documento resume **qué hace** el microservicio `ms-finanzas` y **qué endpoints expone**, agrupados por módulos. Está pensado como guía rápida para entender flujos y responsabilidades (no reemplaza la orquestación detallada ni los contratos en `05. Documentacion/markdown/Contratos/ms-finanzas/`).

## 1) Responsabilidad del microservicio (visión general)

`ms-finanzas` gestiona el **ciclo financiero y de tesorería** de la empresa: cuentas por pagar, solicitudes de giro, tesorería (caja/bancos), conciliaciones bancarias, programación de pagos, letras/canje y maestros tributarios. Se integra sincrónicamente vía Feign con `ms-core-maestros` (maestros compartidos) y `ms-contabilidad` (asientos automáticos).

- **Maestros**: bancos, cuentas bancarias, conceptos financieros, grupos/códigos de flujo de caja NIIF, autorizadores de giro, detracciones SPOT, retenciones IGV.
- **CxP (FI304)**: cuentas por pagar, notas débito/crédito (FI320), documentos directos sin OC (CXP-DIRECTO).
- **Giros (FI307/FI308) + Liquidaciones (FI323/FI324)**: solicitudes con flujo de aprobación y liquidaciones con cierre contable.
- **Tesorería (FI309/FI310/FI312/FI326)**: movimientos de caja/bancos (C/P/T/A) con ejecución y asientos contables.
- **Conciliación bancaria (FI347)**: cuadre de movimientos vs extracto por cuenta + periodo.
- **Programación de pagos (FI356)**: planificación y ejecución de pagos masivos.
- **Canje (CXP-LETRAS-CANJE)**: conversión de facturas en letras de cambio.

Patrón de implementación típico:

- **Controller**: valida request, delega al **Service**, arma respuesta `ApiResponse<T>`.
- **Service**: reglas de negocio + transacciones; usa **Feign clients** para integrar con `ms-contabilidad`, `ms-core-maestros` y `ms-auth-security`.
- **Repository / JPA**: persistencia en esquema `finanzas`.

## 2) Módulos y endpoints (por controlador)

> **Base URL (dev):** `https://api.dev.contabilidad.restaurant.pe`  
> **Prefijo común:** `/api/finanzas`  
> **Token requerido:** Definitivo (Bearer JWT post-selección de empresa)  
> **Response wrapper:** `ApiResponse<T>` con `success/message/errorCode/data/timestamp`

### A. Maestros / configuración

Cada maestro CRUD sigue el mismo patrón:

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar (paginado) |
| `GET` | `/{id}` | Obtener por ID |
| `POST` | `/` | Crear |
| `PUT` | `/{id}` | Actualizar |
| `DELETE` | `/{id}` | Eliminar |
| `PATCH` | `/{id}/activar` | Activar |
| `PATCH` | `/{id}/desactivar` | Desactivar |

#### Bancos (`BancoController`)
- Ruta base: `/api/finanzas/bancos`
- CRUD completo. Soporta `codigoSwift`, `tipoEntidad` (BANCO/FINANCIERA/COOPERATIVA).

#### Cuentas bancarias (`CuentaBancariaController`)
- Ruta base: `/api/finanzas/cuentas-bancarias`
- CRUD completo + `GET /{id}/saldo` (consulta saldo actual de la cuenta).

#### Conceptos financieros (`ConceptoFinancieroController`)
- Ruta base: `/api/finanzas/conceptos-financieros`
- CRUD completo. Campos: `tipoConcepto` (GASTO/INGRESO/TRANSFERENCIA), `afectaContabilidad`, `planContableDetId`.

#### Grupos de flujo de caja (`GrupoCodigoFlujoCajaController`)
- Ruta base: `/api/finanzas/grupos-flujo-caja` (según mapeo real en controller)
- CRUD completo. `nivelNiif`: 1=Operativas, 2=Inversión, 3=Financiamiento.

#### Códigos de flujo de caja (`CodigoFlujoCajaController`)
- Ruta base: `/api/finanzas/codigos-flujo-caja`
- CRUD completo. FK a grupo + `codigoNiif`.

#### Autorizadores de giro (`AutorizadorGiroController`)
- Ruta base: `/api/finanzas/autorizadores-giro`
- CRUD completo.
- Adicional:
  - `GET /centro-costo/{centroCostoId}` — autorizadores por centro de costo
  - `GET /centro-costo/{centroCostoId}/activos` — solo activos

#### Detracciones (`DetraccionController`)
- Ruta base: `/api/finanzas/detracciones`
- CRUD completo + activar/desactivar.

#### Retenciones (`RetencionController`)
- Ruta base: `/api/finanzas/retenciones`
- CRUD completo + activar/desactivar.

---

### B. Cuentas por Pagar — FI304 (`CntasPagarController`)

Ruta base: `/api/finanzas/cuentas-pagar`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar CxP (filtros: proveedor, tipo doc, estado, fechas) |
| `GET` | `/{id}` | Detalle de CxP |
| `POST` | `/` | Crear CxP (genera asiento contable automático) |
| `PUT` | `/{id}` | Actualizar CxP |
| `POST` | `/{id}/anular` | Anular CxP (solo si no tiene pagos/notas aplicadas) |

**Estados:** ACTIVO(1) → ANULADO(0) → PARCIAL(4) → PAGADO(5)

---

### C. Notas Débito/Crédito — FI320 (`NotaController`)

Ruta base: `/api/finanzas/cuentas-pagar/notas`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar notas |
| `GET` | `/{id}` | Detalle de nota |
| `POST` | `/` | Crear nota (débito/crédito sobre CxP) |
| `POST` | `/{id}/anular` | Anular nota |

---

### D. Documentos Directos — CXP-DIRECTO (`DocumentoDirectoController`)

Ruta base: `/api/finanzas/cuentas-pagar/directos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar documentos directos |
| `GET` | `/{id}` | Detalle |
| `POST` | `/` | Crear directo (CxP sin OC, sin asiento automático) |
| `PUT` | `/{id}` | Actualizar directo |
| `POST` | `/{id}/anular` | Anular directo |

---

### E. Solicitudes de Giro — FI307/FI308 (`SolicitudGiroController`)

Ruta base: `/api/finanzas/solicitudes-giro`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar solicitudes (filtros: fechas, estado) |
| `GET` | `/{id}` | Detalle |
| `POST` | `/` | Crear solicitud |
| `PUT` | `/{id}` | Actualizar solicitud |
| `POST` | `/{id}/anular` | Anular solicitud |

Aprobación:
| `GET` | `/pendientes-aprobacion` | Solicitudes pendientes de aprobación |
| `POST` | `/{id}/aprobar` | Aprobar (verifica autorizador del centro de costo) |
| `POST` | `/{id}/rechazar` | Rechazar |

Devolución total — FI333:
| `POST` | `/{id}/devolucion-total` | Solicitar devolución |
| `POST` | `/{id}/aprobar-devolucion-total` | Aprobar devolución |
| `POST` | `/{id}/rechazar-devolucion-total` | Rechazar devolución |

**Estados:** PENDIENTE(3) → APROBADO(1) → RECHAZADO(2) → ANULADO(0)

---

### F. Liquidaciones — FI323/FI324 (`LiquidacionController`)

Ruta base: `/api/finanzas/liquidaciones`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar liquidaciones |
| `GET` | `/{id}` | Detalle |
| `POST` | `/` | Crear liquidación (asociada a solicitud aprobada) |
| `PUT` | `/{id}` | Actualizar liquidación |
| `POST` | `/{id}/anular` | Anular (solo si no está cerrada) |
| `GET` | `/{id}/validacion-cierre` | Validar cierre (cuadre importe neto vs suma detalles) |
| `POST` | `/{id}/cerrar` | Cerrar liquidación (genera asiento contable) |

**Estados:** ACTIVO(1) → CERRADO(2) → ANULADO(0)

---

### G. Caja / Bancos — Tesorería FI309/FI310/FI312/FI326 (`CajaBancosController`)

Ruta base: `/api/finanzas/caja-bancos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar movimientos (filtros: tipo, cuenta, fechas, estado, entidad) |
| `GET` | `/{id}` | Detalle del movimiento |
| `POST` | `/` | Crear movimiento (Cobro/Pago/Transferencia/Aplicación) |
| `PUT` | `/{id}` | Actualizar movimiento |
| `POST` | `/{id}/ejecutar` | **Ejecutar** (actualiza saldo + genera asiento vía Feign) |
| `POST` | `/{id}/anular` | Anular movimiento |

**Tipos:**
- **C** — Cobro (cartera cobros)
- **P** — Pago (cartera pagos)
- **T** — Transferencia entre cuentas
- **A** — Aplicación de documentos

**Estados:** ACTIVO(1) → EJECUTADO(2) → ANULADO(0)

---

### H. Conciliación Bancaria — FI347 (`ConciliacionBancariaController`)

Ruta base: `/api/finanzas/conciliaciones-bancarias`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar conciliaciones (filtros: cuenta, periodo) |
| `GET` | `/{id}` | Detalle |
| `POST` | `/` | Crear conciliación (cuenta + periodo) |
| `PUT` | `/{id}` | Actualizar conciliación |
| `POST` | `/{id}/conciliar` | Conciliar partidas seleccionadas |
| `POST` | `/{id}/cerrar` | Cerrar (solo si diferencia = 0) |

**Estados:** ABIERTO(1) → CERRADO(2)

---

### I. Programación de Pagos — FI356 (`ProgramacionPagoController`)

Ruta base: `/api/finanzas/programacion-pagos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar programaciones (filtros: fechas, estado) |
| `GET` | `/{id}` | Detalle |
| `POST` | `/` | Crear programación |
| `PUT` | `/{id}` | Actualizar programación |
| `POST` | `/{id}/ejecutar` | **Ejecutar** (genera Pagos + reduce saldos CxP) |
| `POST` | `/{id}/anular` | Anular programación |

**Estados:** PROGRAMADO(1) → EJECUTADO(2)

---

### J. Letras de Canje — CXP-LETRAS-CANJE (`LetraCanjeController`)

Ruta base: `/api/finanzas/letras-canje`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar canjes (filtros: referencia, proveedor, fechas) |
| `GET` | `/{referencia}` | Obtener canje por referencia |
| `POST` | `/` | **Ejecutar canje** (convierte facturas en letras) |
| `POST` | `/{referencia}/anular` | Anular canje (restaura saldos) |

---

### K. Admin / Test Data (`TestDataAdminController`)

Ruta base: `/api/finanzas/admin/test-data`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `POST` | `/seed` | Seed masivo de datos demo en core, rrhh, finanzas y contabilidad |

- Controlado por `app.testdata.enabled` (por defecto `true` en desarrollo).
- En producción forzar `APP_TESTDATA_ENABLED=false` (responde 403).

---

## 3) Integraciones vía Feign

| Cliente | MS destino | Endpoints usados |
|---------|------------|-----------------|
| `ContabilidadClient` | `ms-contabilidad` | `POST /asientos/generar/registro-cntas-pagar`, `/cartera-pagos`, `/cartera-cobros`, `/transferencias`, `/aplicacion-documentos`, `/liquidacion-giro` + `POST /asientos/{id}/anular` |
| `CoreMaestrosClient` | `ms-core-maestros` | Monedas, sucursales, catálogos SUNAT, entidades contribuyentes, tipos de documento, series, plan contable, centros de costo, formas de pago, impuestos |
| `AuthSecurityClient` | `ms-auth-security` | `GET /usuarios/{id}` — validación de usuarios |

## 4) Flujo típico (alto nivel)

1. **Configurar maestros** (bancos → cuentas → conceptos → flujo caja → autorizadores).
2. **Registrar CxP** (facturas de proveedores, con o sin OC). Generan asiento contable.
3. **Crear solicitudes de giro** que pasan por aprobación (según autorizadores del centro de costo).
4. Aprobadas → **liquidar** (rendir gastos) y **cerrar** (asiento contable).
5. **Programar pagos** y **ejecutarlos** (afectan saldos CxP y generan pagos).
6. En tesorería:
   - Registrar movimientos de **caja/bancos** (cobros, pagos, transferencias).
   - **Ejecutarlos** para afectar saldos y generar asientos contables.
7. **Conciliar** movimientos bancarios por cuenta + periodo.
8. Opcional: **canje** de facturas por letras según necesidad.

## 5) Reglas de negocio críticas

1. **Token Definitivo** obligatorio en todos los endpoints (`empresaId`, `sucursalId`, `usuarioId` en claims).
2. **Asientos contables automáticos**: CxP, pagos, cobros, liquidaciones generan asiento vía `ms-contabilidad`.
3. **Validación de maestros**: toda FK se valida contra `ms-core-maestros` vía Feign antes de persistir.
4. **Autorización de giros**: solo usuarios registrados como autorizadores del centro de costo pueden aprobar.
5. **Afectación de saldos**: los movimientos de caja/bancos solo afectan saldo al ejecutarse (estado 2).
6. **Conciliación cero**: solo se cierra si diferencia = 0.
7. **Retenciones**: se activan/desactivan, no se anulan.
8. **Devoluciones**: se gestionan como acciones sobre la solicitud de giro (`/{id}/devolucion-total`), no como recurso independiente.

## 6) Errores estandarizados

| Rango | Módulo |
|-------|--------|
| FIN-001 a FIN-031 | Validación de maestros |
| FIN-101 a FIN-206 | Cuentas por Pagar |
| FIN-301 | Fechas |
| FIN-401 a FIN-411 | Letras y Canje |
| FIN-501 a FIN-509 | Solicitudes de Giro |
| FIN-601 a FIN-605 | Liquidaciones |
| FIN-701 a FIN-705 | Conciliación Bancaria |
| FIN-801 a FIN-804 | Detracción |
| FIN-910 a FIN-916 | Retención |
| FIN-900 a FIN-902 | Comunicación con otros MS |
| FIN-998 a FIN-999 | Errores internos |

Orquestación y detalle completo: [`05. Documentacion/orquestacion/ORQUESTACION_MS-FINANZAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-FINANZAS.md).
