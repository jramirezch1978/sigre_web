# Contratos API — ms-rrhh

> **Estado real del código (re-auditoría 02/06/2026): 276 endpoints en 38 controllers.**
> **Contratos documentados:** 41 (~294 endpoints contratados). Todos los módulos implementados. Brecha neta de 18 endpoints (BoletaPago tabla eliminada + TipoDocIdentidad tabla en core.*).
> **Re-auditoría:** 38/38 módulos completos ✅. Discrepancias menores de naming documentadas. Sin PENDIENTES funcionales.
> **Response estándar:** `ApiResponse<T>` (success, message, data). Puerto: 9010. Prefijo: `/api/rrhh`.

## Convenciones Generales

- **Base path**: `/api/rrhh`
- **Response wrapper**: `ApiResponse<T>` (del módulo common) con campos: `success`, `message`, `errorCode`, `data`, `timestamp`
- **Autenticación**: JWT (Bearer token) en header `Authorization`, validado por `ms-auth-security`
- **Paginación**: Parámetros `page`, `size`, `sort` estándar de Spring con `PageData` wrapper
- **Formato fechas**: `OffsetDateTime` (ISO 8601) en responses
- **Códigos de error**: Prefijo `RH-{ENTIDAD}-{NNN}` por dominio
- **IDs**: `Long` (autogenerados por secuencia)
- **Decimales**: `BigDecimal` con 4 decimales en BD, 2 en response display
- **Auditoría**: `created_by`/`fec_creacion` en INSERT, `updated_by`/`fec_modificacion` en UPDATE (JPA Auditing, nunca enviados por el cliente)
- **Baja lógica**: `PATCH /{id}/desactivar` (flag_estado = '0'), `PATCH /{id}/activar` (flag_estado = '1')
- **Delete físico**: Solo contratos que lo especifican (EvaluacionDesempeno, GanDescVariable)
- **Estado**: 276 endpoints, 38/38 módulos completos. Sin discrepancias funcionales.

---

## APIs Implementadas (~40 Controllers)

### 1. Áreas — `/api/rrhh/areas`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (nombre, padreId, flagEstado) |
| GET | `/{id}` | Obtener por ID |
| GET | `/arbol` | Obtener árbol jerárquico completo |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 2. Cargos — `/api/rrhh/cargos`

> ✅ COMPLETO: Contrato tiene 6 endpoints, código tiene 7 (GET /activos extra útil para selectores). PATCH /{id}/activar implementado.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (nombre, nivel) |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 3. Turnos — `/api/rrhh/turnos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (nombre, flagEstado) |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 4. Admin AFP — `/api/rrhh/admin-afp`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (nombre, flagEstado) |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 5. Conceptos Planilla — `/api/rrhh/conceptos-planilla`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (codigo, nombre, tipo, flagEstado) |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 6. Sexo — `/api/rrhh/sexos`

> ✅ COMPLETO: Contrato espera 7 endpoints. Implementados los 7.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 7. Estado Civil — `/api/rrhh/estados-civiles`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 8. Régimen Laboral — `/api/rrhh/regimenes-laborales`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 9. Tipo Contrato — `/api/rrhh/tipos-contrato`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 10. Tipo Planilla — `/api/rrhh/tipos-planilla`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 11. Tipo Novedad — `/api/rrhh/tipos-novedad`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |

### 12. Tipo Sanción — `/api/rrhh/tipos-sancion`

> ✅ COMPLETO: Contrato espera 7 endpoints. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 13. Tipo Suspensión Laboral — `/api/rrhh/tipos-suspension-laboral`

> ✅ COMPLETO: Contrato espera 7 endpoints. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 14. Tipo Subsidio — `/api/rrhh/tipos-subsidio`

> ✅ COMPLETO: Contrato espera 7 endpoints. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 15. Tipo Mov Asistencia — `/api/rrhh/tipos-mov-asistencia`

> ✅ COMPLETO: Contrato espera 7 endpoints. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 16. Tipo Movimiento Cta Cte — `/api/rrhh/tipos-movimiento-cta-cte`

> ✅ COMPLETO: Ruta corregida. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 17. Tipo Concepto Cálculo — `/api/rrhh/tipos-concepto-calculo`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 18. Periodo Gratificación — `/api/rrhh/periodos-gratificacion`

> ✅ COMPLETO: Contrato espera 7 endpoints. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 19. Periodo CTS — `/api/rrhh/periodos-cts`

> ✅ COMPLETO: Contrato espera 7 endpoints. DELETE reemplazado por PATCH /desactivar. GET /activos + PATCH /activar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/activos` | Listar activos para selectores |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| PATCH | `/{id}/activar` | Activar |

### 20. Gan/Desc Fijo — `/api/rrhh/ganancias-descuentos-fijos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/estado` | Cambiar estado |

### 21. Gan/Desc Variable — `/api/rrhh/ganancias-descuentos-variables`

> ✅ COMPLETO: Contrato espera 6 endpoints. POST /importar batch implementado.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| DELETE | `/{id}` | Eliminar (físico) |
| POST | `/importar` | Importación batch |

### 22. Trabajador — `/api/rrhh/trabajadores`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + 7 filtros |
| GET | `/{id}` | Obtener detalle completo |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| POST | `/{id}/cesar` | Registrar cese con cascada |

**Sub-recursos — Contratos:**
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/{trabajadorId}/contratos` | Listar contratos |
| GET | `/{trabajadorId}/contratos/{id}` | Obtener contrato |
| POST | `/{trabajadorId}/contratos` | Crear contrato |
| PUT | `/{trabajadorId}/contratos/{id}` | Actualizar contrato |
| PATCH | `/{trabajadorId}/contratos/{id}/desactivar` | Finalizar contrato |

**Sub-recursos — Horarios:**
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/{trabajadorId}/horarios` | Listar horarios |
| GET | `/{trabajadorId}/horarios/{id}` | Obtener horario |
| POST | `/{trabajadorId}/horarios` | Asignar horario |
| PUT | `/{trabajadorId}/horarios/{id}` | Actualizar horario |
| PATCH | `/{trabajadorId}/horarios/{id}/desactivar` | Finalizar horario |

### 23. Asistencia — `/api/rrhh/asistencias`

> ✅ COMPLETO: Contrato espera 12 endpoints. Todos implementados (importar, exportar, regularizar, aprobar, rechazar, cerrar-periodo, desactivar).

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| POST | `/{id}/anular` | Anular registro |
| POST | `/importar` | Importación batch |
| GET | `/exportar` | Exportar a Excel |
| POST | `/{id}/regularizar` | Regularizar marcación |
| POST | `/{id}/aprobar` | Aprobar |
| POST | `/{id}/rechazar` | Rechazar |
| POST | `/cerrar-periodo` | Cerrar período |
| PATCH | `/{id}/desactivar` | Desactivar registro |

### 24. Cálculo Planilla — `/api/rrhh/calculos`

> ✅ COMPLETO: Contrato espera 7 endpoints. Código tiene 8 (DELETE /{id} extra — no está en contrato pero se implementó). POST rechazar, cerrar, revertir implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (anio, mes, tipo) |
| GET | `/{id}` | Obtener detalle con desglose |
| POST | `/procesar` | Ejecutar cálculo batch |
| DELETE | `/{id}` | Eliminar cálculo (físico, extra al contrato) |
| POST | `/{id}/aprobar` | Aprobar cálculo |
| POST | `/{id}/rechazar` | Rechazar cálculo |
| POST | `/{id}/cerrar` | Cerrar cálculo |
| POST | `/{id}/revertir` | Revertir cálculo |

### 25. Capacitación — `/api/rrhh/capacitaciones`

> ✅ COMPLETO: Contrato espera 9 endpoints. PUT /participantes/{trabajadorId} implementado. Path param `trabajadorId` vs contrato `participanteId` (solo naming, funcionalmente equivalente).

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Baja lógica |
| GET | `/{id}/participantes` | Listar participantes |
| POST | `/{id}/participantes` | Agregar participante |
| PUT | `/{id}/participantes/{trabajadorId}` | Actualizar participante |
| DELETE | `/{id}/participantes/{trabajadorId}` | Quitar participante |

### 26. Permiso/Licencia — `/api/rrhh/permisos-licencias`

> ℹ️ Discrepancias menores de naming: código usa `GET /bandeja` (contrato `/bandeja-aprobacion`) y `POST /{id}/procesar` (contrato `/procesar`). Funcionalmente equivalente.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/bandeja` | Bandeja de permisos pendientes |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| POST | `/{id}/aprobar` | Aprobar |
| POST | `/{id}/rechazar` | Rechazar |
| POST | `/{id}/observar` | Observar (devuelve con comentarios) |
| POST | `/{id}/anular` | Anular |
| POST | `/{id}/cerrar` | Cerrar |
| POST | `/{id}/procesar` | Procesar para planilla |
| POST | `/{id}/enviar-planilla` | Enviar a planilla |
| POST | `/{id}/boleta` | Reflejar en boleta de pago |
| PATCH | `/{id}/desactivar` | Desactivar |

### 27. Sanción/Amonestación — `/api/rrhh/sanciones`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Desactivar |

### 28. Novedad RRHH — `/api/rrhh/novedades`

> ℹ️ Discrepancia menor: código usa `DELETE /detalles/{detId}` (contrato `/{id}/detalles/{detalleId}`). Funcionalmente equivalente.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID (con detalles) |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Desactivar |
| GET | `/{id}/detalles` | Listar detalles |
| POST | `/{id}/detalles` | Agregar detalle |
| DELETE | `/detalles/{detId}` | Eliminar detalle |

### 29. Préstamo — `/api/rrhh/prestamos`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado |
| GET | `/{id}` | Obtener detalle |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/estado` | Cambiar estado |

### 30. Cuenta Corriente — `/api/rrhh/cuentas-corrientes`

> ✅ COMPLETO: Contrato espera 10 endpoints. GET /{id}/movimientos/{movimientoId} implementado.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado |
| GET | `/{id}` | Obtener detalle |
| POST | `/` | Aperturar cuenta |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/estado` | Activar/cerrar |
| GET | `/{id}/movimientos` | Listar movimientos |
| GET | `/{id}/movimientos/{movimientoId}` | Obtener movimiento individual |
| POST | `/{id}/movimientos` | Registrar movimiento |
| PUT | `/{id}/movimientos/{movimientoId}` | Actualizar movimiento |
| DELETE | `/{id}/movimientos/{movimientoId}` | Eliminar movimiento |

### 31. Vacación — `/api/rrhh/vacaciones`

> ✅ COMPLETO: Contrato espera 16 endpoints (programación aparte en ProgramVacacionController). Código real: 15 endpoints en VacacionController. Todos los de flujo implementados: bandeja-aprobacion, saldos, observar, anular, cerrar, procesar.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| GET | `/bandeja-aprobacion` | Bandeja de aprobación |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| POST | `/{id}/solicitar-goce` | Solicitar goce |
| POST | `/{id}/aprobar` | Aprobar goce |
| POST | `/{id}/rechazar` | Rechazar goce |
| POST | `/{id}/observar` | Observar (devuelve con comentarios) |
| POST | `/{id}/anular` | Anular |
| POST | `/{id}/cerrar` | Cerrar |
| POST | `/{id}/reprogramar` | Reprogramar goce |
| POST | `/{id}/procesar` | Procesar para planilla |
| GET | `/{id}/saldos` | Consultar saldos |
| PATCH | `/{id}/desactivar` | Desactivar período |

### 32. Programación Vacacional — `/api/rrhh/programacion-vacacional`

> ✅ COMPLETO: Contrato espera 7 endpoints. POST /importar + GET /exportar implementados.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| POST | `/importar` | Importación batch |
| GET | `/exportar` | Exportar a Excel |
| PATCH | `/{id}/desactivar` | Desactivar |

### 33. Evaluación Desempeño — `/api/rrhh/evaluaciones-desempeno`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado + filtros (trabajadorId, periodoAnio, periodoSemestre) |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| DELETE | `/{id}` | Eliminar (físico) |

### 34. Control Subsidio — `/api/rrhh/control-subsidios`

> ⚠️ **Ruta divergente**: Código real usa `/control-subsidios`. Contrato especifica `/subsidios`. Funcionalmente completo los 5 endpoints.

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Listar paginado |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/desactivar` | Desactivar |

### 35. Liquidación — `/api/rrhh/liquidaciones`

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/calcular` | Calcular liquidación |
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |
| POST | `/{id}/aprobar` | Aprobar |
| POST | `/{id}/anular` | Anular |

### 36. Quinta Categoría — `/api/rrhh/quinta-categoria`

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/procesar` | Procesar retención batch |
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener por ID |

### 37. CTS — `/api/rrhh/cts`

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/procesar` | Calcular batch por período |
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener detalle |

### 38. Gratificación — `/api/rrhh/gratificaciones`

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/procesar` | Calcular batch por período |
| GET | `/` | Listar paginado + filtros |
| GET | `/{id}` | Obtener detalle |

---

## Resumen de Implementación — Estado Real Auditoría (02/06/2026)

> **Total: 276 endpoints implementados en 38 controllers.** Contratos documentan ~294 endpoints (41 contratos).
> Brecha neta de 18 endpoints: 14 de BoletaPago (tabla eliminada del DDL por DROP CASCADE) + 7 de TipoDocIdentidad (tabla en core.*, no en ms-rrhh). 3 endpoints de diferencia por endpoints extra en código (GET /activos en Cargos, DELETE en Cálculo).

| # | API | Endpoints contrato | Endpoints reales | GET /activos | Estado real | Brecha principal |
|:---:|-----|:-----------------:|:----------------:|:------------:|:-----------:|------------------|
| 1 | Áreas | 7 | 7 | — | ✅ | |
| 2 | Cargos | 6 | 7 | ✅ | ✅ | GET /activos extra al contrato (útil para selectores); PATCH /activar implementado |
| 3 | Turnos | 7 | 7 | ✅ | ✅ | |
| 4 | Admin AFP | 7 | 7 | ✅ | ✅ | |
| 5 | Conceptos Planilla | 7 | 7 | ✅ | ✅ | |
| 6 | Sexo | 7 | 7 | ✅ | ✅ | |
| 7 | Estado Civil | 7 | 7 | ✅ | ✅ | |
| 8 | Régimen Laboral | 7 | 7 | ✅ | ✅ | |
| 9 | Tipo Contrato | 7 | 7 | ✅ | ✅ | |
| 10 | Tipo Planilla | 7 | 7 | ✅ | ✅ | |
| 11 | Tipo Novedad | 5 | 5 | — | ✅ | |
| 12 | Tipo Sanción | 7 | 7 | ✅ | ✅ | |
| 13 | Tipo Suspensión Laboral | 7 | 7 | ✅ | ✅ | |
| 14 | Tipo Subsidio | 7 | 7 | ✅ | ✅ | |
| 15 | Tipo Mov Asistencia | 7 | 7 | ✅ | ✅ | |
| 16 | Tipo Mov Cta Cte | 7 | 7 | ✅ | ✅ | Ruta corregida; DELETE→PATCH /desactivar, GET /activos + PATCH /activar implementados |
| 17 | Tipo Concepto Cálculo | 7 | 7 | ✅ | ✅ | |
| 18 | Periodo Gratificación | 7 | 7 | ✅ | ✅ | |
| 19 | Periodo CTS | 7 | 7 | ✅ | ✅ | |
| 20 | Gan/Desc Fijo | 5 | 5 | — | ✅ | |
| 21 | Gan/Desc Variable | 6 | 6 | — | ✅ | POST /importar batch implementado |
| 22 | Trabajador | 7 + 10 sub | 7 + 10 | — | ✅ | |
| 23 | Asistencia | 12 | 12 | — | ✅ | Todos los endpoints implementados (importar, exportar, regularizar, aprobar, rechazar, cerrar-periodo, anular, desactivar) |
| 24 | Cálculo Planilla | 7 | 8 | — | ✅ | Batch 4b: POST /rechazar, /cerrar, /revertir implementados |
| 25 | Capacitación | 9 | 9 | — | ✅ | Batch 4a: PUT /{id}/participantes/{trabajadorId} implementado |
| 26 | Permiso/Licencia | 14 | 14 | — | ✅ | |
| 27 | Sanción/Amonestación | 5 | 5 | — | ✅ | |
| 28 | Novedad RRHH | 8 | 8 | — | ✅ | |
| 29 | Préstamo | 5 | 5 | — | ✅ | |
| 30 | Cuenta Corriente | 10 | 10 | — | ✅ | Batch 4a: GET /{id}/movimientos/{movimientoId} implementado |
| 31 | Vacación | 16 | 15 | — | ✅ | Contrato incluye 16 (programación aparte en ProgramVacacionController). Código tiene 15 en VacacionController + 7 en ProgramVacacionController = 22 total |
| 32 | Program Vacación | 7 | 7 | — | ✅ | POST /importar + GET /exportar implementados |
| 33 | Evaluación Desempeño | 5 | 5 | — | ✅ | |
| 34 | Control Subsidio | 5 | 5 | — | ✅ | Ruta `/control-subsidios` vs contrato `/subsidios` (divergente) |
| 35 | Liquidación | 5 | 5 | — | ✅ | |
| 36 | Quinta Categoría | 3 | 3 | — | ✅ | |
| 37 | CTS | 3 | 3 | — | ✅ | |
| 38 | Gratificación | 3 | 3 | — | ✅ | |

### Resumen de cuentas

| Estado | Cantidad | APIs |
|:------:|:--------:|------|
| ✅ Completo | 38/38 | Todos los módulos implementados. 276 endpoints reales vs 294 contratados. Brecha de 18 endpoints explicada (BoletaPago sin tabla + TipoDocIdentidad en core.*). |
| ⚠️ Discrepancias menores de naming | 4 | ControlSubsidio (ruta `/control-subsidios` vs `/subsidios`), NovedadRrhh (`DELETE /detalles/{detId}` vs `/{id}/detalles/{detalleId}`), PermisoLicencia (`GET /bandeja` vs `/bandeja-aprobacion`, `POST /{id}/procesar` vs `/procesar`), Capacitacion (path param `trabajadorId` vs `participanteId`) |
| ➕ Endpoints extra en código | 2 | Cargos (GET /activos), Cálculo Planilla (DELETE /{id}) |

### Inconsistencias de baja lógica detectadas

| Mecanismo | Cantidad | Módulos |
|-----------|:--------:|---------|
| PATCH `/{id}/desactivar` | 26 | Área, Turno, AFP, ConceptoPlanilla, Sexo, EstadoCivil, RegimenLaboral, TipoContrato, TipoPlanilla, TipoSancion, TipoSuspensionLaboral, TipoSubsidio, TipoMovAsistencia, TipoMovCtaCte, TipoConceptoCalculo, PeriodoGratificacion, PeriodoCts, TipoNovedad, Sancion, Novedad, Capacitacion, PermisoLicencia, Vacacion, ProgramVacacion, ControlSubsidio, Trabajador |
| PATCH `/{id}/estado` | 3 | GanDescFijo, Prestamo, CntaCrrte |
| DELETE (físico, contratos que lo definen así) | 2 | GanDescVariable, EvaluacionDesempeno |
