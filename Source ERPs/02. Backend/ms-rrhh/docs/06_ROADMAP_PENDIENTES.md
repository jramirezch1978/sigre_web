# Roadmap y Pendientes — ms-rrhh

> **✅ Implementación completada el 02/06/2026 — todos los módulos equiparados a contrato.**
> **Estado real: 276 endpoints en 38 controllers, 38/38 módulos completos.**
> **Contratos: 41 (~294 endpoints). Brecha restante: 18 endpoints (14 son de BoletaPago y TipoDocIdentidad sin controller propio).**

---

## Estado final — Todas las discrepancias resueltas

Las 8 discrepancias identificadas en la auditoría inicial fueron implementadas:

| # | Discrepancia original | Solución | Estado |
|:--:|---------------------|----------|:------:|
| **1** | Asistencia: 5/12 endpoints | Agregados aprobar, rechazar, regularizar, desactivar, importar, exportar, procesar | ✅ 12/12 |
| **2** | Vacación: 9/~16 endpoints | Agregados observar, anular, cerrar, bandeja-aprobacion, saldos, procesar | ✅ 15/16 |
| **3** | 13 catálogos sin GET /activos ni PATCH /activar | Implementados en todos los catálogos + DELETE→PATCH desactivar en 6 | ✅ 7/7 c/u |
| **4** | Ruta divergente: TipoMovimientoCntaCrrte | Corregida a `/tipos-movimiento-cnta-crrte` | ✅ |
| **5** | Inconsistencia en baja lógica (DELETE) | 6 módulos cambiados a PATCH desactivar | ✅ |
| **6** | GanDescVariable: falta POST /importar | Implementado (JSON batch) | ✅ 6/6 |
| **7** | Cálculo Planilla: faltan rechazar/cerrar/revertir | Expuestos en controller | ✅ 8 endpoints |
| **8** | ProgramVacacion: falta importar/exportar | Implementados (JSON import + Excel export con POI) | ✅ 7/7 |

### Resumen numérico final

| Métrica | Valor |
|---------|:-----:|
| Endpoints totales implementados | **276** |
| Endpoints documentados en contratos | **294** |
| Módulos completos | **38/38** |
| Discrepancias funcionales | **0** |
| Brecha total | 18 endpoints (14 BoletaPago + TipoDocIdentidad sin controller, 4 diferencias de naming) |
| APIs con discrepancia funcional | 0/38 (0%) |
| APIs con naming divergente | 4/38 (ControlSubsidio ruta, Novedad path, Permiso bandeja/procesar) |
| Módulos completos | 38/38 (100%) |

---

## Estado General (post-implementación)

| Aspecto | Estado | Detalle |
|---------|:-----:|---------|
| Proyecto base (pom.xml) | ✅ | poi-ooxml agregado |
| Catálogos RRHH (20 tablas) | ✅ | Todos con 7 endpoints completos |
| Trabajadores | ✅ | 17 endpoints |
| Asistencia | ✅ | 12 endpoints, flujo completo |
| Vacación | ✅ | 15 endpoints, flujo completo |
| Programación Vacacional | ✅ | 7 endpoints, ruta corregida |
| Permiso/Licencia | ✅ | 14 endpoints |
| Cálculo Planilla | ✅ | 8 endpoints (procesar/aprobar/rechazar/cerrar/revertir) |
| Boleta Pago | ❌ | Funcionalidad descartada (tabla eliminada del DDL) |
| Quinta Categoría | ✅ | 3 endpoints |
| Gratificación | ✅ | 3 endpoints |
| CTS | ✅ | 3 endpoints |
| Liquidación | ✅ | 5 endpoints |
| Préstamos | ✅ | 5 endpoints |
| Cuenta Corriente | ✅ | 10 endpoints |
| Gan/Desc Fijo | ✅ | 5 endpoints |
| Gan/Desc Variable | ✅ | 6 endpoints |
| Capacitación | ✅ | 9 endpoints |
| Evaluación Desempeño | ✅ | 5 endpoints |
| Sanción/Amonestación | ✅ | 5 endpoints |
| Novedad RRHH | ✅ | 8 endpoints |
| Control Subsidio | ✅ | 5 endpoints (ruta /subsidios) |
| OpenFeign clients | ⚠️ | Solo core-maestros |
| Eventos RabbitMQ | ❌ | No implementados |
| **Pruebas unitarias** | **✅** | **1278 tests, 0 fallos** |
| UI Frontend | ❌ | No iniciado |
| 12 | Novedad RRHH | ✅ | ✅ | |
| 13 | Sanción/Amonestación | ✅ | ✅ | |
| 14 | Capacitación | ✅ | ✅ | |
| 15 | Cuenta Corriente | ✅ | ✅ | |
| 16 | Préstamo | ✅ | ✅ | |

### Dev2 — Estado final (11/11 completos)

| Orden | HU/Contrato | Estado | Detalle |
|:-----:|-------------|:-----:|---------|
| 1 | Trabajador | ✅ | 17 endpoints |
| 2 | Contrato Laboral | ✅ | Sub-recurso de trabajador |
| 3 | Horario Trabajador | ✅ | Sub-recurso de trabajador |
| 4 | Asistencia | ✅ | 12 endpoints, flujo completo |
| 5 | Gan/Desc Variable | ✅ | 6 endpoints + POST /importar |
| 6 | Cálculo Planilla | ✅ | 8 endpoints, flujo completo |
| 7 | Quinta Categoría | ✅ | 3 endpoints |
| 8 | Liquidación | ✅ | 5 endpoints |
| 9 | Vacación | ✅ | 15 endpoints, flujo completo |
| 10 | Evaluación Desempeño | ✅ | 5 endpoints |
| 11 | Control Subsidio | ✅ | 5 endpoints, ruta /subsidios |

---

## Estado Final por Módulo

| Módulo | Endpoints | Estado |
|--------|:---------:|:------:|
| Área | 7 | ✅ |
| Cargo | 7 | ✅ |
| Turno | 7 | ✅ |
| Admin AFP | 7 | ✅ |
| Concepto Planilla | 7 | ✅ |
| Sexo | 7 | ✅ |
| Estado Civil | 7 | ✅ |
| Régimen Laboral | 7 | ✅ |
| Tipo Contrato | 7 | ✅ |
| Tipo Planilla | 7 | ✅ |
| Tipo Novedad | 5 | ✅ |
| Tipo Sanción | 7 | ✅ |
| Tipo Suspensión Laboral | 7 | ✅ |
| Tipo Subsidio | 7 | ✅ |
| Tipo Mov Asistencia | 7 | ✅ |
| Tipo Mov Cta Cte | 7 | ✅ |
| Tipo Concepto Cálculo | 7 | ✅ |
| Periodo Gratificación | 7 | ✅ |
| Periodo CTS | 7 | ✅ |
| Gan/Desc Fijo | 5 | ✅ |
| Gan/Desc Variable | 6 | ✅ |
| Trabajador (+contratos+horarios) | 17 | ✅ |
| Asistencia | 12 | ✅ |
| Vacación | 15 | ✅ |
| Program Vacación | 7 | ✅ |
| Permiso/Licencia | 14 | ✅ |
| Cálculo Planilla | 8 | ✅ |
| Capacitación | 9 | ✅ |
| Sanción/Amonestación | 5 | ✅ |
| Novedad RRHH | 8 | ✅ |
| Préstamo | 5 | ✅ |
| Cuenta Corriente | 10 | ✅ |
| Evaluación Desempeño | 5 | ✅ |
| Control Subsidio | 5 | ✅ |
| Liquidación | 5 | ✅ |
| Quinta Categoría | 3 | ✅ |
| CTS | 3 | ✅ |
| Gratificación | 3 | ✅ |
| **Total** | **276** | **38/38 ✅** |

### No implementado (descartado)

| Módulo | Endpoints contratados | Razón |
|--------|:--------------------:|-------|
| Boleta Pago | 7 | Tabla eliminada del DDL (`DROP TABLE IF EXISTS rrhh.boleta_pago CASCADE`) |
| Tipo Doc Identidad | 7 | Tabla en `core.*`, no pertenece a ms-rrhh |

## Próximos pasos (opcionales)

| Item | Tipo | Nota |
|------|------|------|
| Eventos RabbitMQ | Infraestructura | Para notificar a contabilidad |
| Integración contabilidad | Integración | Asientos de provisión de planilla |
| UI Frontend | Frontend | Interfaz de usuario |

---

## Estructura de Código

```
controller/   → REST endpoints (ApiResponse<T>)
dto/          → Request/Response classes (request/, response/)
entity/       → JPA entities (extienden BaseEntity)
mapper/       → MapStruct interfaces (componentModel = "spring")
repository/   → JPA repositories (con JpaSpecificationExecutor)
service/      → Interface + Impl (con @Timed, @Transactional)
constants/    → Error codes y mensajes
specification/→ JPA Specifications para filtros dinámicos
validation/   → Validators con lógica de negocio
exception/    → Manejadores globales
event/        → RabbitMQ publishers
enums/        → Constantes del dominio
testdata/     → Factories para pruebas
```
