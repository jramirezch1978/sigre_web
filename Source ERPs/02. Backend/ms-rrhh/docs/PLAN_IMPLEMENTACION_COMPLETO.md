# Plan de Implementación Completo — ms-rrhh (Dev 1, Items 8-16)

> **✅ ESTADO: Todos los items de este plan fueron implementados.** Re-auditoría 02/06/2026 confirma **276 endpoints** en producción, 38/38 módulos completos.
> **Basado en:** HU y CONTRATO de cada item en `05. Documentacion/markdown/Contratos/ms-rrhh/`
> **Referencia:** Patrón de ms-produccion, ConceptoPlanilla (código existente)
> **Estándar pruebas:** TEST_STANDARDS.md v2.0 (misma convención A/B/C)

---

## Índice

- [Orden de Implementación](#orden-de-implementación)
- [Fase 1 — Gestión de Personal](#fase-1--gestión-de-personal-items-11-13-14)
  - [Item 11: Permiso/Licencia](#item-11-permisolicencia)
  - [Item 13: Sanción/Amonestación](#item-13-sanciónamonestación)
  - [Item 14: Capacitación](#item-14-capacitación)
- [Fase 2 — Beneficios Legales](#fase-2--beneficios-legales-items-9-10)
  - [Item 9: Gratificación](#item-9-gratificación)
  - [Item 10: CTS](#item-10-cts)
- [Fase 3 — Novedades](#fase-3--novedades-item-12)
  - [Item 12: Novedad RRHH](#item-12-novedad-rrhh)
- [Fase 4 — Procesos y Financiero](#fase-4--procesos-y-financiero-items-8-15-16)
  - [Item 8: Boleta de Pago](#item-8-boleta-de-pago)
  - [Item 15: Cuenta Corriente](#item-15-cuenta-corriente)
  - [Item 16: Préstamo](#item-16-préstamo)
- [Estándares Transversales](#estándares-transversales)

---

## Orden de Implementación

```
FASE 1 (Gestión Personal):  Item 11 → Item 13 → Item 14
FASE 2 (Beneficios Legales): Item 9  → Item 10
FASE 3 (Novedades):           Item 12
FASE 4 (Procesos/Financiero): Item 8  → Item 15 → Item 16
```

---

## FASE 1 — Gestión de Personal (Items 11, 13, 14)

Estos son los más sencillos: CRUD con lógica de negocio básica. Ideales para empezar.

---

### Item 11: Permiso/Licencia

**Contrato:** `CONTRATO_PERMISO_LICENCIA.md` (316 líneas) · `HU_PERMISO_LICENCIA.md`
**Tabla DDL:** `rrhh.permiso_licencia` (líneas 447-463)
**Ruta base:** `/api/rrhh/permisos-licencias`
**Prefijo error:** `RH-PL-*`

#### Endpoints

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| GET | `/` | 200 | Listar paginado (filtros: trabajadorId, fechaDesde, fechaHasta, flagEstado) |
| GET | `/{id}` | 200 | Obtener por ID |
| POST | `/` | 201 | Crear |
| PUT | `/{id}` | 200 | Actualizar |
| POST | `/{id}/aprobar` | 200 | Aprobar (flagEstado = '2') |
| POST | `/{id}/rechazar` | 200 | Rechazar (flagEstado = '0') |
| PATCH | `/{id}/desactivar` | 200 | Baja lógica |

#### Entity — `PermisoLicencia`

Extiende `BaseEntity`. No tiene código único (usa ID).

| Campo JPA | Columna BD | Tipo | Restricciones |
|-----------|-----------|------|---------------|
| trabajadorId | trabajador_id | Long | @NotNull, FK → rrhh.trabajador |
| tipoSuspensionLaboralId | tipo_suspension_laboral_id | Long | @NotNull, FK → rrhh.tipo_suspension_laboral |
| fechaInicio | fecha_inicio | LocalDate | @NotNull |
| fechaFin | fecha_fin | LocalDate | |
| dias | dias | Integer | |
| sustento | sustento | String | |

**Catálogo adicional:** `TipoSuspensionLaboral` — crear entity completa (id, codigo, nombre, flagTipoSusp, tipoSubsidioId, flagCitt, flagEstado).

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-PL-001 | 400 | Datos incompletos (@Valid) |
| RH-PL-002 | 404 | Trabajador inexistente |
| RH-PL-003 | 400 | Fecha fin < fecha inicio |
| RH-PL-004 | 409 | Solapamiento con otro permiso activo (mismo trabajador, fechas se cruzan) |
| RH-PL-005 | 409 | Ya aprobado/rechazado (POST aprobar/rechazar) |

#### Archivos a crear (~25)

```
constants/PermisoLicenciaConstants.java
controller/PermisoLicenciaController.java
dto/request/PermisoLicenciaCreateRequest.java
dto/request/PermisoLicenciaUpdateRequest.java
dto/response/PermisoLicenciaResponse.java
entity/PermisoLicencia.java
entity/TipoSuspensionLaboral.java (catálogo adicional)
mapper/PermisoLicenciaMapper.java
mapper/TipoSuspensionLaboralMapper.java
repository/PermisoLicenciaRepository.java
repository/TipoSuspensionLaboralRepository.java
service/PermisoLicenciaService.java
service/impl/PermisoLicenciaServiceImpl.java
specification/PermisoLicenciaSpecification.java
validation/PermisoLicenciaValidator.java
```

**Modificar:** RrhhErrorCodes, RrhhTestDataFactory, RrhhTestFixtures, TestDataSeederRrhh

#### Orden sugerido

Constants → Entity → Repository → DTOs → Mapper → Specification → Validator → Service → Controller → Factory B → Fixtures C → Seed → Tests

---

### Item 13: Sanción/Amonestación

**Contrato:** `CONTRATO_SANCION_AMONESTACION.md` (244 líneas)
**Tabla DDL:** `rrhh.sancion_amonestacion` (líneas 583-598)
**Ruta base:** `/api/rrhh/sanciones`
**Prefijo error:** `RH-SA-*`

#### Endpoints

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| GET | `/` | 200 | Listar paginado (filtros: trabajadorId, tipoSancionId, fechaDesde, fechaHasta) |
| GET | `/{id}` | 200 | Obtener por ID |
| POST | `/` | 201 | Crear |
| PUT | `/{id}` | 200 | Actualizar |
| PATCH | `/{id}/desactivar` | 200 | Baja lógica |

#### Entity — `SancionAmonestacion`

| Campo | Tipo | Restricciones |
|-------|------|---------------|
| trabajadorId | Long | @NotNull, FK → rrhh.trabajador |
| tipoSancionId | Long | @NotNull, FK → rrhh.tipo_sancion |
| fecha | LocalDate | @NotNull |
| motivo | String | |
| documento | String | |

**Catálogo adicional:** `TipoSancion` (ya en DDL línea 265-276).

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-SA-001 | 400 | Datos incompletos |
| RH-SA-002 | 404 | Trabajador inexistente |
| RH-SA-003 | 404 | Tipo sanción inexistente |
| RH-SA-004 | 400 | Fecha futura no permitida |
| RH-SA-005 | 404 | No encontrado |

#### Archivos a crear (~22)

```
constants/SancionAmonestacionConstants.java
controller/SancionAmonestacionController.java
dto/request/SancionAmonestacionCreateRequest.java
dto/request/SancionAmonestacionUpdateRequest.java
dto/response/SancionAmonestacionResponse.java
entity/SancionAmonestacion.java
entity/TipoSancion.java
mapper/SancionAmonestacionMapper.java
repository/SancionAmonestacionRepository.java
repository/TipoSancionRepository.java
service/SancionAmonestacionService.java
service/impl/SancionAmonestacionServiceImpl.java
specification/SancionAmonestacionSpecification.java
validation/SancionAmonestacionValidator.java
```

---

### Item 14: Capacitación

**Contrato:** `CONTRATO_CAPACITACION.md` (365 líneas)
**Tablas DDL:** `rrhh.capacitacion` (líneas 147-162), `rrhh.capacitacion_trabajador` (líneas 567-581)
**Ruta base:** `/api/rrhh/capacitaciones`
**Prefijo error:** `RH-CA-*`

#### Endpoints

**Capacitaciones (cabecera):**

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| GET | `/` | 200 | Listar paginado |
| GET | `/{id}` | 200 | Obtener por ID |
| POST | `/` | 201 | Crear |
| PUT | `/{id}` | 200 | Actualizar |
| PATCH | `/{id}` | 200 | Baja lógica |

**Participantes (sub-recurso):**

| Método | Ruta | Status |
|--------|------|:------:|
| GET | `/{id}/participantes` | 200 |
| POST | `/{id}/participantes` | 201 |
| PATCH | `/{id}/participantes/{trabajadorId}` | 200 |

#### Entities

**Capacitacion** (BaseEntity): nombre, descripcion, fechaInicio, fechaFin, horas, proveedor, costo.
**CapacitacionTrabajador**: capacitacionId, trabajadorId, asistio (boolean), calificacion, certificado (boolean).

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-CA-001 | 400 | Nombre obligatorio |
| RH-CA-002 | 400 | Fecha fin < fecha inicio |
| RH-CA-003 | 422 | No desactivar con participantes |
| RH-CA-004 | 404 | No encontrado |
| RH-CA-005 | 409 | Participante duplicado |

#### Archivos a crear (~28)

```
constants/CapacitacionConstants.java
controller/CapacitacionController.java
dto/request/CapacitacionCreateRequest.java / CapacitacionUpdateRequest.java
dto/request/CapacitacionTrabajadorRequest.java
dto/response/CapacitacionResponse.java
dto/response/CapacitacionTrabajadorResponse.java
entity/Capacitacion.java / CapacitacionTrabajador.java
mapper/CapacitacionMapper.java / CapacitacionTrabajadorMapper.java
repository/CapacitacionRepository.java / CapacitacionTrabajadorRepository.java
service/CapacitacionService.java / impl/CapacitacionServiceImpl.java
specification/CapacitacionSpecification.java
validation/CapacitacionValidator.java
```

---

## FASE 2 — Beneficios Legales (Items 9, 10)

Procesos batch con lógica de cálculo, similar a `CosteoProduccion` en ms-produccion.

---

### Item 9: Gratificación

**Contrato:** `CONTRATO_GRATIFICACION.md` (242 líneas)
**Tablas DDL:** `rrhh.gratificacion` (líneas 760-777), `rrhh.periodo_gratificacion` (líneas 317-328)
**Ruta base:** `/api/rrhh/gratificaciones`
**Prefijo error:** `RH-GR-*`

#### Endpoints

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| POST | `/procesar` | 201 | Ejecutar cálculo batch |
| GET | `/` | 200 | Listar paginado |
| GET | `/{id}` | 200 | Obtener detalle |

#### Entity — `Gratificacion`

Extiende `AuditOnlyMappedEntity` (sin flagEstado — es resultado de cálculo).

| Campo | Tipo | Restricciones |
|-------|------|---------------|
| trabajadorId | Long | @NotNull, FK → rrhh.trabajador |
| anio | Integer | @NotNull |
| periodoGratificacionId | Long | @NotNull, FK → rrhh.periodo_gratificacion |
| remuneracionComputable | BigDecimal | @NotNull |
| mesesLaborados | Integer | @NotNull |
| montoGratificacion | BigDecimal | @NotNull |
| bonificacionExtraordinaria | BigDecimal | |
| total | BigDecimal | @NotNull |

**UK:** `(trabajador_id, anio, periodo_gratificacion_id)` — idempotencia.

**Catálogo:** `PeriodoGratificacion` (JULIO, DICIEMBRE).

#### Lógica de Cálculo Batch

```java
@Transactional
public List<GratificacionResponse> procesar(Integer anio, Long periodoGratificacionId) {
    // 1. Validar período
    PeriodoGratificacion periodo = periodoRepository.findById(periodoGratificacionId)
        .orElseThrow(() -> new BusinessException(RH_GR_002));

    // 2. Buscar trabajadores activos con contrato vigente en el período
    List<Trabajador> trabajadores = trabajadorRepository.findActivosEnPeriodo(anio, periodo);

    // 3. Por cada trabajador calcular
    for (Trabajador t : trabajadores) {
        // remuneracion_computable = sueldo + asignacion_familiar + promedio_bonos
        // meses_laborados = meses del período
        // monto_gratificacion = (remuneracion_computable / 6) * meses_laborados
        // bonificacion_extraordinaria = 9% de monto_gratificacion (Essalud)
        // total = monto + bonificacion
        // upsert por UK (trabajador_id, anio, periodo)
    }

    // 4. Publicar evento RabbitMQ (planificado)
    // 5. Retornar resultado
}
```

#### Archivos a crear (~20)

```
constants/GratificacionConstants.java
controller/GratificacionController.java
dto/request/GratificacionProcesarRequest.java
dto/response/GratificacionResponse.java
entity/Gratificacion.java / PeriodoGratificacion.java
mapper/GratificacionMapper.java
repository/GratificacionRepository.java / PeriodoGratificacionRepository.java
service/GratificacionService.java / impl/GratificacionServiceImpl.java
```

---

### Item 10: CTS

**Contrato:** `CONTRATO_CTS.md` (252 líneas)
**Tablas DDL:** `rrhh.cts` (líneas 779-798), `rrhh.periodo_cts` (líneas 330-341)
**Ruta base:** `/api/rrhh/cts`
**Prefijo error:** `RH-CT-*`

#### Endpoints

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| POST | `/procesar` | 201 | Ejecutar cálculo batch |
| GET | `/` | 200 | Listar paginado |
| GET | `/{id}` | 200 | Obtener detalle |

#### Entity — `Cts`

Extiende `AuditOnlyMappedEntity`. Campos: trabajadorId, anio, periodoCtsId, remuneracionComputable, mesesComputables, diasComputables, montoCts, entidadFinanciera, numeroCuentaCts, fechaDeposito.

**UK:** `(trabajador_id, anio, periodo_cts_id)`.

#### Lógica de Cálculo

```java
// remuneracion_computable = sueldo + (1/6 gratificacion) + asignacion_familiar
// meses_computables = meses laborados en semestre
// dias_computables = días adicionales
// monto_cts = (rem_computable / 12) * meses + (rem_computable / 360) * dias
```

Mismo patrón que Gratificación: batch service, idempotente, sin flagEstado.

---

## FASE 3 — Novedades (Item 12)

### Item 12: Novedad RRHH

**Contrato:** `CONTRATO_NOVEDAD_RRHH.md` (396 líneas)
**Tablas DDL:** `rrhh.novedad_rrhh` (líneas 672-686), `rrhh.novedad_rrhh_det` (líneas 746-758)
**Ruta base:** `/api/rrhh/novedades`
**Prefijo error:** `RH-NV-*`

#### Endpoints

**Novedades (cabecera):**

| Método | Ruta | Status | Descripción |
|--------|------|:------:|-------------|
| GET | `/` | 200 | Listar (filtros: trabajadorId, tipoNovedadId, fechaDesde, fechaHasta) |
| GET | `/{id}` | 200 | Obtener con detalles |
| POST | `/` | 201 | Crear con detalles |
| PUT | `/{id}` | 200 | Actualizar |
| PATCH | `/{id}` | 200 | Baja lógica |

**Detalles (sub-recurso):**

| Método | Ruta | Status |
|--------|------|:------:|
| GET | `/{id}/detalles` | 200 |
| POST | `/{id}/detalles` | 201 |
| PUT | `/detalles/{detId}` | 200 |
| PATCH | `/detalles/{detId}` | 200 |

#### Entities

**NovedadRrhh** (BaseEntity): trabajadorId, tipoNovedadRrhhId, citt, fechaIni, fechaFin, diasTeoricos, diasReales.
**NovedadRrhhDet** (BaseEntity): novedadRrhhId, fechaProceso, montoPlanilla, montoSeguro, referenciaDoc.

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-NV-001 | 400 | Datos incompletos |
| RH-NV-002 | 404 | Tipo novedad inexistente |
| RH-NV-003 | 400 | Fecha fin < fecha inicio |
| RH-NV-004 | 409 | Ya existe novedad del mismo tipo en el período |
| RH-NV-005 | 404 | No encontrado |
| RH-NV-006 | 422 | No desactivar si está referenciado en planilla |

---

## FASE 4 — Procesos y Financiero (Items 15, 16)

### Item 8: Boleta de Pago — ❌ ELIMINADO

Funcionalidad descartada. La tabla `boleta_pago` y sus archivos Java fueron eliminados del DDL y del código fuente.
| RH-BP-002 | 409 | Cálculo no aprobado para emitir |
| RH-BP-003 | 500 | Error al generar PDF |
| RH-BP-004 | 500 | Error al enviar boleta |

---

### Item 15: Cuenta Corriente

**Contrato:** `CONTRATO_CUENTA_CORRIENTE.md` (338 líneas)
**Tablas DDL:** `rrhh.cnta_crrte` (líneas 519-532), `rrhh.cnta_crrte_det` (líneas 729-744), `rrhh.tipo_movimiento_cnta_crrte` (líneas 304-315)
**Ruta base:** `/api/rrhh/cuentas-corrientes`
**Prefijo error:** `RH-CC-*`

#### Endpoints

**Cuenta Corriente:**

| Método | Ruta | Status |
|--------|------|:------:|
| GET | `/` | 200 |
| GET | `/{id}` | 200 |
| POST | `/` | 201 |
| PUT | `/{id}` | 200 |
| PATCH | `/{id}/estado` | 200 |

**Movimientos (sub-recurso):**

| Método | Ruta | Status |
|--------|------|:------:|
| GET | `/{id}/movimientos` | 200 |
| POST | `/{id}/movimientos` | 201 |

#### Entities

**CntaCrrte** (BaseEntity): trabajadorId (FK, UNIQUE), fechaApertura, saldoInicial, saldoActual.
**CntaCrrteDet** (BaseEntity): cntaCrrteId (FK), fechaMovimiento, tipoMovimientoCntaCrrteId (FK), concepto, monto, referencia.

**Catálogo:** `TipoMovimientoCntaCrrte` (CREDITO, DEBITO, ABONO, AJUSTE, INTERES).

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-CC-001 | 400 | Datos incompletos |
| RH-CC-002 | 409 | Cuenta duplicada (ya existe para el trabajador) |
| RH-CC-003 | 422 | No cerrar con saldo != 0 |
| RH-CC-004 | 422 | Movimiento sobre cuenta cerrada/inactiva |

---

### Item 16: Préstamo

**Contrato:** `CONTRATO_PRESTAMO.md` (226 líneas)
**Tabla DDL:** `rrhh.prestamo` (líneas 503-517)
**Ruta base:** `/api/rrhh/prestamos`
**Prefijo error:** `RH-PR-*`

#### Endpoints

| Método | Ruta | Status |
|--------|------|:------:|
| GET | `/` | 200 |
| GET | `/{id}` | 200 |
| POST | `/` | 201 |
| PUT | `/{id}` | 200 |
| PATCH | `/{id}/estado` | 200 |

#### Entity — `Prestamo`

Extiende `BaseEntity`. Campos: trabajadorId, montoTotal, cuotas, cuotaMensual, saldo.

#### Estados

- `'1'` = Activo (en cobranza)
- `'0'` = Cancelado (pagado totalmente)
- `'2'` = Castigado (incobrable)

#### Validaciones

| Código | HTTP | Regla |
|--------|:----:|-------|
| RH-PR-001 | 400 | Datos incompletos |
| RH-PR-002 | 404 | Trabajador inexistente |
| RH-PR-003 | 400 | Monto ≤ 0 o cuotas ≤ 0 |
| RH-PR-004 | 409 | No modificar si ya tiene cuotas descontadas en planilla |

---

## Estándares Transversales

### Para TODOS los items

1. **Entity**: extiende `BaseEntity` (tiene flagEstado) o `AuditOnlyMappedEntity` (sin flagEstado para procesos batch)
2. **Repository**: extiende `JpaRepository<T, Long>` + opcional `JpaSpecificationExecutor<T>`
3. **Mapper**: `@Mapper(componentModel = "spring")`, ignorar id/auditoría en toEntity
4. **Service**: interface + impl, `@Timed` en impl, `@Transactional(readOnly = true)` a nivel clase
5. **Controller**: `@RestController`, `@RequestMapping`, retorna `ApiResponse<T>`
6. **Constants**: clase final con constructor privado, constantes de error y mensajes
7. **Validator**: `@Component`, lógica de negocio separada
8. **Specification**: filtros dinámicos con JPA Criteria API

### Testing

- **Unit tests**: Constants, Mapper, Validator, Specification, Service
- **Integration tests**: Controller (MockMvc + Testcontainers)
- **Fixtures C**: modificar `RrhhTestFixtures`
- **Factory B**: modificar `RrhhTestDataFactory`
- **Seed**: modificar `TestDataSeederRrhh`
- **Coverage apuntar a**: 100% en Constants, Mapper, Validator, Specification, Service; Controller via IT

### Comandos

```bash
# Compilar
mvn compile -pl ms-rrhh

# Tests unitarios de un item
mvn test -pl ms-rrhh -Dtest="*PermisoLicencia*"

# Integration tests
mvn test -pl ms-rrhh -Dgroups=integration -Dtest="*PermisoLicencia*"

# Cobertura completa
mvn clean verify -pl ms-rrhh
```
