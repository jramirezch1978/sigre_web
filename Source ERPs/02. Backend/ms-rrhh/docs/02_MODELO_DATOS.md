# Modelo de Datos — ms-rrhh

> Basado en el DDL real: `03. Base de datos/ddl/tenant/07-rrhh.sql` (969 líneas, 42 tablas)
> Esquema: `rrhh` | Motor: PostgreSQL 16+

---

## Diagrama de Relaciones

```
area → area (self-ref padre_id)
cargo, admin_afp, turno, concepto_planilla, tipo_novedad_rrhh, capacitacion
  → (independientes)
sexo, estado_civil, regimen_laboral, tipo_contrato, tipo_mov_asistencia,
tipo_subsidio, tipo_suspension_laboral, tipo_sancion, tipo_planilla,
tipo_concepto_calculo, tipo_movimiento_cnta_crrte, periodo_gratificacion, periodo_cts
  → (catálogos independientes)
calculo → tipo_planilla
trabajador → core.entidad_contribuyente, core.tipo_doc_identidad, sexo,
             estado_civil, regimen_laboral, admin_afp, area, cargo, auth.sucursal
contrato → trabajador, tipo_contrato
asistencia → trabajador, tipo_mov_asistencia
permiso_licencia → trabajador, tipo_suspension_laboral
vacacion → trabajador
program_vacacion → trabajador
liquidacion → trabajador
prestamo → trabajador
cnta_crrte → trabajador
cnta_crrte_det → cnta_crrte, tipo_movimiento_cnta_crrte
horario_trabajador → trabajador, turno
evaluacion_desempeno → trabajador
capacitacion_trabajador → capacitacion, trabajador
sancion_amonestacion → trabajador, tipo_sancion
control_subsidio → trabajador, tipo_subsidio
gan_desct_fijo → trabajador, concepto_planilla
gan_desct_variable → trabajador, concepto_planilla, tipo_planilla
novedad_rrhh → trabajador, tipo_novedad_rrhh
novedad_rrhh_det → novedad_rrhh
calculo_det → calculo, trabajador, concepto_planilla, tipo_concepto_calculo
gratificacion → trabajador, periodo_gratificacion
cts → trabajador, periodo_cts
quinta_categoria → trabajador
```

---

## Tablas Maestras (Independientes)

### area
| Columna | Tipo | Constraint |
|---------|------|-----------|
| id | BIGSERIAL | PK |
| nombre | VARCHAR(120) | NOT NULL |
| padre_id | BIGINT | FK → area(id) |
| responsable_id | BIGINT | |
| flag_estado | VARCHAR(1) | NOT NULL DEFAULT '1' |

### cargo
| Columna | Tipo | Constraint |
|---------|------|-----------|
| id | BIGSERIAL | PK |
| nombre | VARCHAR(120) | NOT NULL |
| nivel | VARCHAR(30) | |
| sueldo_minimo | NUMERIC(18,4) | |
| sueldo_maximo | NUMERIC(18,4) | |

### admin_afp
| Columna | Tipo | Constraint |
|---------|------|-----------|
| id | BIGSERIAL | PK |
| nombre | VARCHAR(120) | NOT NULL |
| comision_porcentaje | NUMERIC(8,4) | |
| prima_seguro | NUMERIC(8,4) | |
| aporte_obligatorio | NUMERIC(8,4) | |

### turno
| Columna | Tipo | Constraint |
|---------|------|-----------|
| id | BIGSERIAL | PK |
| nombre | VARCHAR(120) | NOT NULL |
| hora_entrada | TIME | |
| hora_salida | TIME | |
| minutos_tolerancia | INTEGER | DEFAULT 0 |
| aplica_lunes..domingo | BOOLEAN | Por defecto solo L-V |

### concepto_planilla
| Columna | Tipo | Constraint |
|---------|------|-----------|
| id | BIGSERIAL | PK |
| codigo | VARCHAR(20) | NOT NULL UNIQUE |
| nombre | VARCHAR(150) | NOT NULL |
| tipo | VARCHAR(30) | NOT NULL (INGRESO/DESCUENTO/APORTE) |
| formula | TEXT | |
| valor_fijo | NUMERIC(18,4) | |
| afecto_quinta | BOOLEAN | DEFAULT FALSE |
| afecto_essalud | BOOLEAN | DEFAULT FALSE |
| aplica_todos | BOOLEAN | DEFAULT TRUE |

---

## Catálogos RRHH — Estado Real (vs docs desactualizados)

> ✅ **Actualizado:** Todos los catálogos implementan los 7 endpoints del contrato, incluyendo `GET /activos`, `PATCH /activar` y `PATCH /desactivar`.

| Tabla | Controller | Service | Entity/Repo | GET /activos | Estado |
|-------|:----------:|:-------:|:-----------:|:------------:|:------:|
| sexo | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| estado_civil | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| regimen_laboral | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_contrato | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_doc_identidad | — | — | core (externo) | N/A | N/A |
| tipo_mov_asistencia | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_subsidio | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_suspension_laboral | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_sancion | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_planilla | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_concepto_calculo | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_movimiento_cnta_crrte | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| periodo_gratificacion | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| periodo_cts | ✅ | ✅ | ✅ | ✅ | ✅ Completo |
| tipo_novedad_rrhh | ✅ | ✅ | ✅ | N/A (usa DELETE) | ✅ Completo |

---

## Tablas del Núcleo de RRHH

### trabajador (entidad central)
FKs: `core.entidad_contribuyente`, `core.tipo_doc_identidad`, `sexo`, `estado_civil`,
`regimen_laboral`, `admin_afp`, `area`, `cargo`, `auth.sucursal`

### contrato (sub-recurso de trabajador)
FKs: `trabajador`, `tipo_contrato`. Solo 1 activo por trabajador.

### asistencia
FKs: `trabajador`, `tipo_mov_asistencia`.

### permiso_licencia
FKs: `trabajador`, `tipo_suspension_laboral`. Estados: 1=Solicitado, 2=Aprobado, 0=Rechazado.

### calculo (proceso batch)
FK: `tipo_planilla`. Estados batch: BORRADOR/APROBADO/RECHAZADO/CERRADO (en proceso batch, no en entity).

> **Boleta de pago:** no tiene tabla propia. Se obtiene agrupando `calculo_det` por `calculo_id` + `trabajador_id` (consulta/PDF/emisión).

### gan_desct_fijo
FKs: `trabajador`, `concepto_planilla`.

### gan_desct_variable
FKs: `trabajador`, `concepto_planilla`, `tipo_planilla`.

### gratificacion
FKs: `trabajador`, `periodo_gratificacion`.

### cts
FKs: `trabajador`, `periodo_cts`.

### liquidacion
FK: `trabajador`. Estados: 1=Pendiente, 2=Aprobada, 0=Anulada.

### quinta_categoria
FK: `trabajador`.

### prestamo
FK: `trabajador`.

### cnta_crrte
FK: `trabajador`.

### cnta_crrte_det
FKs: `cnta_crrte`, `tipo_movimiento_cnta_crrte`.

### novedad_rrhh
FKs: `trabajador`, `tipo_novedad_rrhh`.

### novedad_rrhh_det
FK: `novedad_rrhh`.

### horario_trabajador (sub-recurso de trabajador)
FKs: `trabajador`, `turno`. Solo 1 activo, sin solapamientos.

### capacitacion
Independiente.

### capacitacion_trabajador (pivote)
FKs: `capacitacion`, `trabajador`.

### sancion_amonestacion
FKs: `trabajador`, `tipo_sancion`.

### vacacion
FK: `trabajador`. Controller implementado (15 endpoints). ✅ Completo: incluye bandeja-aprobacion, saldos, observar, anular, cerrar, procesar.

### program_vacacion
FK: `trabajador`. Controller implementado (7 endpoints). ✅ Completo: incluye importar/exportar, ruta /vacaciones/programacion.

### evaluacion_desempeno
FK: `trabajador`. Controller implementado (5 endpoints). ✅

### control_subsidio
FKs: `trabajador`, `tipo_subsidio`. Controller implementado (5 endpoints). ✅

---

## Estado de Implementación por Tabla

| # | Tabla | Controller | Service | Entity/Repo | Estado |
|:---:|-------|:----------:|:-------:|:-----------:|:------:|
| 1 | area | ✅ | ✅ | ✅ | ✅ |
| 2 | cargo | ✅ | ✅ | ✅ | ✅ |
| 3 | turno | ✅ | ✅ | ✅ | ✅ |
| 4 | admin_afp | ✅ | ✅ | ✅ | ✅ |
| 5 | concepto_planilla | ✅ | ✅ | ✅ | ✅ |
| 6 | tipo_novedad_rrhh | ✅ | ✅ | ✅ | ✅ |
| 7 | gan_desct_fijo | ✅ | ✅ | ✅ | ✅ |
| 8 | gan_desct_variable | ✅ | ✅ | ✅ | ✅ |
| 9 | trabajador | ✅ | ✅ | ✅ | ✅ |
| 10 | contrato | ✅ (sub) | ✅ | ✅ | ✅ |
| 11 | horario_trabajador | ✅ (sub) | ✅ | ✅ | ✅ |
| 12 | asistencia | ✅ | ✅ | ✅ | ✅ |
| 13 | permiso_licencia | ✅ | ✅ | ✅ | ✅ |
| 14 | vacacion | ✅ | ✅ | ✅ | ✅ (15 endpoints, flujo completo) |
| 15 | program_vacacion | ✅ | ✅ | ✅ | ✅ (7 endpoints, ruta corregida) |
| 16 | calculo | ✅ | ✅ | ✅ | ✅ (8 endpoints, flujo completo) |
| 17 | calculo_det | — | — | ✅ | Sin controller directo |
| 18 | ~~boleta_pago~~ (eliminada) | — | — | — | Tabla eliminada del DDL; funcionalidad descartada |
| 19 | gratificacion | ✅ | ✅ | ✅ | ✅ |
| 21 | cts | ✅ | ✅ | ✅ | ✅ |
| 22 | liquidacion | ✅ | ✅ | ✅ | ✅ |
| 23 | quinta_categoria | ✅ | ✅ | ✅ | ✅ |
| 24 | prestamo | ✅ | ✅ | ✅ | ✅ |
| 25 | cnta_crrte | ✅ | ✅ | ✅ | ✅ |
| 26 | cnta_crrte_det | ✅ (sub) | ✅ | ✅ | ✅ |
| 27 | novedad_rrhh | ✅ | ✅ | ✅ | ✅ |
| 28 | novedad_rrhh_det | ✅ (sub) | ✅ | ✅ | ✅ |
| 29 | sancion_amonestacion | ✅ | ✅ | ✅ | ✅ |
| 30 | capacitacion | ✅ | ✅ | ✅ | ✅ |
| 31 | capacitacion_trabajador | ✅ (sub) | ✅ | ✅ | ✅ |
| 32 | evaluacion_desempeno | ✅ | ✅ | ✅ | ✅ |
| 33 | control_subsidio | ✅ | ✅ | ✅ | ✅ |
| 34 | tipo_sancion | ✅ | ✅ | ✅ | ✅ |
| 35 | tipo_suspension_laboral | ✅ | ✅ | ✅ | ✅ |
| 36 | periodo_gratificacion | ✅ | ✅ | ✅ | ✅ |
| 37 | periodo_cts | ✅ | ✅ | ✅ | ✅ |
| 38 | sexo | ✅ | ✅ | ✅ | ✅ |
| 39 | estado_civil | ✅ | ✅ | ✅ | ✅ |
| 40 | regimen_laboral | ✅ | ✅ | ✅ | ✅ |
| 41 | tipo_contrato | ✅ | ✅ | ✅ | ✅ |
| 42 | tipo_mov_asistencia | ✅ | ✅ | ✅ | ✅ |
| 43 | tipo_subsidio | ✅ | ✅ | ✅ | ✅ |
| 44 | tipo_planilla | ✅ | ✅ | ✅ | ✅ |
| 45 | tipo_concepto_calculo | ✅ | ✅ | ✅ | ✅ |
| 46 | tipo_movimiento_cnta_crrte | ✅ | ✅ | ✅ | ✅ |

---

## Notas sobre Discrepancias DDL vs Entities

1. **created_by/updated_by**: DDL `BIGINT` (FK a `auth.usuario`), entities `String` (consistente con ms-produccion).
2. **Migraciones idempotentes**: El DDL incluye migraciones para pasar de columnas VARCHAR a FK (legado).
3. **FK diferida**: `finanzas.cntas_pagar_det.trabajador_id → rrhh.trabajador(id)` para pagos de nómina.
4. **Turno**: Vive en `model/`, no en `entity/`. Extiende `BaseEntity`.
5. **Catálogos en core**: `tipo_doc_identidad` es tabla del esquema `core`, no de `rrhh`. No hay entity `TipoDocIdentidad` en ms-rrhh (HU_TIPO_DOC_IDENTIDAD.md existe pero la tabla es externa).
6. **Turno**: Vive en `entity/Turno.java`, no en `entity/`. Extiende `BaseEntity` y tiene su propio controller.
7. **Cuenta Corriente**: El código usa `CntaCrrte` (abreviatura), la HU usa `CuentaCorriente`. Son la misma entidad.
8. **Contrato / HorarioTrabajador**: No tienen controller propio. Se gestionan como sub-recursos de `TrabajadorController` (`/trabajadores/{id}/contratos`, `/trabajadores/{id}/horarios`).
9. **Entidades detalle**: `calculo_det`, `capacitacion_trabajador`, `cnta_crrte_det`, `novedad_rrhh_det` no tienen controller propio. Se gestionan a través de su entidad padre.
